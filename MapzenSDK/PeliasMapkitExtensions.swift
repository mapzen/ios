//
//  MapkitExtensions.swift
//  pelias-ios-sdk
//
//  Created by Matt on 7/12/16.
//  Copyright © 2016 Mapzen. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation
import Pelias

/*

 Typical search response format is in GeoJSON - http://geojson.org/geojson-spec.html

 Example:
 {
	"geocoding": {
 "version": "0.1",
 "attribution": "https://search.mapzen.com/v1/attribution",
 "query": {
 "text": "cool",
 "size": 1,
 "private": false
 },
 "engine": {
 "name": "Pelias",
 "author": "Mapzen",
 "version": "1.0"
 },
 "timestamp": 1451940120154
	},
	"type": "FeatureCollection",
	"features": [{
 "type": "Feature",
 "properties": {
 "id": "3577127899",
 "gid": "osm:venue:3577127899",
 "layer": "venue",
 "source": "osm",
 "name": "Cool",
 "country_a": "GRC",
 "country": "Greece",
 "region": "ΚΡΗΤΗ",
 "locality": "Î¡ÎÎÎ¥ÎÎÎÎ",
 "confidence": 0.711,
 "label": "Cool, Î¡ÎÎÎ¥ÎÎÎÎ, Greece"
 },
 "geometry": {
 "type": "Point",
 "coordinates": [24.474645, 35.371769]
 }
	}],
	"bbox": [-98.01126, 32.8000597029494, 67.34516, 56.034896]
 }

 */

public let PeliasIDKey: String = "PeliasOSMIDKey"
public let PeliasDataSourceKey: String = "PeliasDataSourceKey"

/**
 `PeliasMapkitAnnotation` is a data object class that provides MapKit compatible annotation objects. It conforms to `MKAnnotation` protocol and is also used by the Mapzen iOS SDK for annotations (markers in Tangram-es).
 */
open class PeliasMapkitAnnotation: NSObject, MKAnnotation {

  open let coordinate: CLLocationCoordinate2D
  open let title: String?
  open let subtitle: String?
  open let data: [String: AnyObject]?
  open weak var target: UIResponder?
  open var selector: Selector?

  /**
   Create a fully formed `PeliasMapkitAnnotation`

   - parameter coordinate: A CLLocationCoordinate2D object for lat/long placement
   - parameter title: An optional title for the annotation
   - parameter subtitle: An optional subtitle for the annotation
   - parameter data: An optional data dictionary useful for communicating additional metadata about an annotation

   - returns: A fully formed `PeliasMapkitAnnotation`
   */
  public init(coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?, data: [String:AnyObject]?) {
    self.coordinate = coordinate
    self.title = title
    self.subtitle = subtitle
    self.data = data
  }

  /**
   Sets a target for the selector which will be invoked when the annotation is clicked.
   
   - parameter target: A target to invoke the selector on when the annotation is clicked
   - parameter action: An selector to be invoked on the target when the annotation is clicked
   */
  public func setTarget(target actionTarget: UIResponder, action: Selector) {
    target = actionTarget
    selector = action
  }
}

public extension PeliasResponse {
  /**
   Produces an array of PeliasMapkitAnnotations based off the response from Pelias servers. 
   
   This is currently the only method for producing fully formed native objects. In the future there will be additional functions and data types for this class to produce additional / more detailed objects.
  */
  public func parsedMapItems() -> [PeliasMapkitAnnotation]? {
    return parsedMapItems(target: nil, action: nil)
  }

  /**
   Produces an array of PeliasMapkitAnnotations based off the response from Pelias servers.

   This is currently the only method for producing fully formed native objects. In the future there will be additional functions and data types for this class to produce additional / more detailed objects.

   - Parameter target: An optional target to invoke the selector on when the annotations are clicked.
   - Parameter action: An optional selector to be invoked when the created annotations are clicked.
   */
  public func parsedMapItems(target: UIResponder?, action: Selector?) -> [PeliasMapkitAnnotation]? {
    //TODO: This should get refactored into eventually being a real GeoJSON decoder, and split out the MapItem creation
    var mapItems = [PeliasMapkitAnnotation]()
    guard let jsonDictionary: Dictionary = parsedResponse?.parsedResponse else { return nil }
    guard let featuresArray = jsonDictionary["features"] as? [Dictionary<String, Any>] else {
      return nil
    }
    for feature in featuresArray {
      //Address Dictionary for Placemark Creation
      let featureProperties = feature["properties"] as? [String:AnyObject]
      var addressDictionary = [String:AnyObject]()
      addressDictionary[PeliasIDKey] = featureProperties?["id"]
      addressDictionary[PeliasDataSourceKey] = featureProperties?["source"]

      //Coordinate Creation
      let featureGeometry = feature["geometry"] as? [String:AnyObject]
      let geometryPosition = featureGeometry?["coordinates"] as? [Double]
      let lat = geometryPosition?[1] ?? 0.0
      let lng = geometryPosition?[0] ?? 0.0
      let coordinate = CLLocationCoordinate2DMake(lat, lng)

      //MKPlacemark
      let name = featureProperties?["label"] as? String
      let mapAnnotation = PeliasMapkitAnnotation(coordinate: coordinate, title: name, subtitle: nil, data: addressDictionary)
      if let target = target, let action = action {
        mapAnnotation.setTarget(target: target, action: action)
      }

      mapItems.append(mapAnnotation)
    }
    return mapItems;
  }
}
/// Extension that applies conformance to MKMapItem for older iOS versions (conformance was added it seems in iOS 10)
extension MKMapItem: MKAnnotation {
  public var coordinate: CLLocationCoordinate2D{
    get {
      return self.placemark.coordinate
    }
  }

  public var title: String?{
    get {
      return self.name
    }
  }
}

public extension SearchBoundaryRect {
  /**
   Initializer for creating a boundary rect based off a Mapkit view's rectangle. It does a bit of math to determine the bounding box based off of map kit's available data.
   
   - parameter mapRect: An MKMapRect representing the rectangle we wish to bind to (usually whatever the map is displaying currently full screen on the device)
   
   - returns: A SearchBoundaryRect structure useful for limiting Pelias searches to a particular area
  */
  public init(mapRect: MKMapRect){
    //Since we get a coordinate and a size, we need to convert this into the bounding box pelias expects.
    //First convert the origin point to the min lat/long
    let minCoordinate = MKCoordinateForMapPoint(mapRect.origin)

    //Now we need to figure out the other map point that represents the max
    let mapPointMaxX = mapRect.origin.x + mapRect.size.width
    let mapPointMaxY = mapRect.origin.y + mapRect.size.height
    let mapPointMax = MKMapPoint(x: mapPointMaxX, y: mapPointMaxY)
    let maxCoordinate = MKCoordinateForMapPoint(mapPointMax)

    //We use the origin point latitude for max, and subsequently the computed maxLat for pelias's minimum, because pelias wants lower left and upper right points of the rect.
    self.maxLatLong = Pelias.GeoPoint(latitude: minCoordinate.latitude, longitude: maxCoordinate.longitude)
    self.minLatLong = Pelias.GeoPoint(latitude: maxCoordinate.latitude, longitude: minCoordinate.longitude)
  }
}

public extension Pelias.GeoPoint {
  /**
   Creates a GeoPoint based of CoreLocation data
   
   - parameter location: A CLLocation object for lat/long data
   
   - returns: a full formed GeoPoint
  */
  public init? (location: CLLocation?) {
    guard let unwrappedLocation = location else { return nil }
    self.init(latitude: unwrappedLocation.coordinate.latitude, longitude: unwrappedLocation.coordinate.longitude)
  }
}
