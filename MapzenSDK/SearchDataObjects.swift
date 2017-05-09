//
//  SearchDataObjects.swift
//  ios-sdk
//
//  Created by Sarah Lensing on 3/20/17.
//
//

import Foundation
import Pelias

/// Represents a search request's rectangular boundary.
@objc(MZSearchRect)
public class SearchRect: NSObject {
  let rect: SearchBoundaryRect
  /**
   Initialize a rectangle with given min and max points.
   - parameter minLatLong: Minimum latitude value.
   - parameter maxLatLong: Maximum latitude value.
   */
  public init(minLatLong: GeoPoint, maxLatLong: GeoPoint) {
    rect = SearchBoundaryRect(minLatLong: minLatLong.point, maxLatLong: maxLatLong.point)
  }

  init(boundaryRect: SearchBoundaryRect) {
    rect = boundaryRect
  }

  public override func isEqual(_ object: Any?) -> Bool {
    guard let otherRect = object as? SearchRect else { return false }
    return otherRect.rect == rect
  }
}

/// Represents a search request's circular boundary.
@objc(MZSearchCircle)
public class SearchCircle: NSObject {
  let circle:  SearchBoundaryCircle
  /**
   Initialize a circle with given center and radius.
   - parameter center: Center point.
   - parameter radius: Radius in kilometers.
   */
  public init(center: GeoPoint, radius: Double) {
    circle = SearchBoundaryCircle(center: center.point, radius: radius)
  }

  init(boundaryCircle: SearchBoundaryCircle) {
    circle = boundaryCircle
  }

  public override func isEqual(_ object: Any?) -> Bool {
    guard let otherCircle = object as? SearchCircle else { return false }
    return otherCircle.circle == circle
  }
}

/// Structure used to represent a coordinate point.
@objc(MZGeoPoint)
public class GeoPoint: NSObject {
  let point: Pelias.GeoPoint
  /**
   Initialize a structure with given latitude and longitude.
   - parameter latitude: Latitude.
   - parameter longitude: Longitude.
   */
  public init(latitude: Double, longitude: Double) {
    point = Pelias.GeoPoint(latitude: latitude, longitude: longitude)
  }

  init(geoPoint: Pelias.GeoPoint) {
    point = geoPoint
  }

  public override func isEqual(_ object: Any?) -> Bool {
    guard let otherPoint = object as? GeoPoint else { return false }
    return otherPoint.point == point
  }
}

/// Represents possible sources for search results to be returned from.
@objc(MZSearchSource)
public enum SearchSource: Int {
  case openStreetMap = 1, openAddresses, quattroshapes, geoNames
}

/// Represents a layer to return results for.
@objc(MZLayerFilter)
public enum LayerFilter: Int {
  case venue = 1, address, country, region, county, locality, localadmin, neighbourhood, coarse
}
