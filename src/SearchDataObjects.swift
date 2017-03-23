//
//  SearchDataObjects.swift
//  Pods
//
//  Created by Sarah Lensing on 3/20/17.
//
//

import Foundation
import Pelias

public class SearchRect: NSObject {
  let rect: SearchBoundaryRect
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

public class SearchCircle: NSObject {
  let circle:  SearchBoundaryCircle
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

public class GeoPoint: NSObject {
  let point: Pelias.GeoPoint
  
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

public enum SearchSource: Int {
  case openStreetMap = 1, openAddresses, quattroshapes, geoNames
}

public enum LayerFilter: Int {
  case venue = 1, address, country, region, county, locality, localadmin, neighbourhood, coarse
}

public class PlaceQueryItem: NSObject {

  let peliasItem: PeliasPlaceQueryItem

  public var placeId: String {
    get {
      return peliasItem.placeId
    }
  }

  public var dataSource: SearchSource {
    get {
      return SearchDataConverter.wrapSearchSource(peliasItem.dataSource)
    }
  }

  public var layer: LayerFilter {
    get {
      return SearchDataConverter.wrapLayerFilter(peliasItem.layer)
    }
  }

  public init(placeId: String, dataSource: SearchSource, layer: LayerFilter) {
    let unwrappedSource = SearchDataConverter.unwrapSearchSource(dataSource)
    let unwrappedLayer = SearchDataConverter.unwrapLayerFilter(layer)
    peliasItem = PeliasPlaceQueryItem(placeId: placeId, dataSource: unwrappedSource, layer: unwrappedLayer)
  }

  public override func isEqual(_ object: Any?) -> Bool {
    guard let otherItem = object as? PlaceQueryItem else { return false }
    return otherItem.peliasItem.dataSource == peliasItem.dataSource &&
    otherItem.peliasItem.layer == peliasItem.layer &&
    otherItem.placeId == peliasItem.placeId
  }
}
