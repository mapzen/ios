//
//  MapzenRequestConfig.swift
//  Pods
//
//  Created by Sarah Lensing on 3/20/17.
//
//

import Foundation
import Pelias

public class MzSearchRect: NSObject {
  let rect: SearchBoundaryRect
  public init(minLatLong: MzGeoPoint, maxLatLong: MzGeoPoint) {
    rect = SearchBoundaryRect(minLatLong: minLatLong.point, maxLatLong: maxLatLong.point)
  }

  init(boundaryRect: SearchBoundaryRect) {
    rect = boundaryRect
  }
}

public class MzSearchCircle: NSObject {
  let circle:  SearchBoundaryCircle
  public init(center: MzGeoPoint, radius: Double) {
    circle = SearchBoundaryCircle(center: center.point, radius: radius)
  }

  init(boundaryCircle: SearchBoundaryCircle) {
    circle = boundaryCircle
  }
}

public class MzGeoPoint: NSObject {
  let point: GeoPoint
  public init(latitude: Double, longitude: Double) {
    point = GeoPoint(latitude: latitude, longitude: longitude)
  }

  init(geoPoint: GeoPoint) {
    point = geoPoint
  }
}

public enum MzSearchSource: Int {
  case openStreetMap = 1, openAddresses, quattroshapes, geoNames
}

public enum MzLayerFilter: Int {
  case venue = 1, address, country, region, county, locality, localadmin, neighbourhood, coarse
}

public class MzPlaceQueryItem: NSObject {

  let peliasItem: PeliasPlaceQueryItem

  public var placeId: String {
    get {
      return peliasItem.placeId
    }
  }

  public var dataSource: MzSearchSource {
    get {
      return MapzenSearchDataConverter.wrapSearchSource(peliasItem.dataSource)
    }
  }

  public var layer: MzLayerFilter {
    get {
      return MapzenSearchDataConverter.wrapLayerFilter(peliasItem.layer)
    }
  }

  public init(placeId: String, dataSource: MzSearchSource, layer: MzLayerFilter) {
    let unwrappedSource = MapzenSearchDataConverter.unwrapSearchSource(dataSource)
    let unwrappedLayer = MapzenSearchDataConverter.unwrapLayerFilter(layer)
    peliasItem = PeliasPlaceQueryItem(placeId: placeId, dataSource: unwrappedSource, layer: unwrappedLayer)
  }
}
