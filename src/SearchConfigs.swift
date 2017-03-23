//
//  SearchConfigs.swift
//  ios-sdk
//
//  Created by Sarah Lensing on 3/23/17.
//  Copyright © 2017 Mapzen. All rights reserved.
//

import Foundation
import Pelias

public class MapzenAutocompleteConfig : NSObject {
  let peliasConfig : PeliasAutocompleteConfig

  public var focusPoint: MzGeoPoint {
    get {
      return MapzenSearchDataConverter.wrapPoint(peliasConfig.focusPoint)
    }
  }

  public var searchText: String {
    get {
      return peliasConfig.searchText
    }
  }

  public init(searchText: String, focusPoint: MzGeoPoint, completionHandler: @escaping (MapzenResponse) -> Void) {
    let unwrappedPoint = MapzenSearchDataConverter.unwrapPoint(focusPoint)
    peliasConfig = PeliasAutocompleteConfig(searchText: searchText, focusPoint: unwrappedPoint, completionHandler: { (response) in
      let mapzenResponse = MapzenResponse.init(response)
      completionHandler(mapzenResponse)
    })
  }
}

public class MapzenPlaceConfig : NSObject {
  let peliasConfig: PeliasPlaceConfig

  public var places: [MzPlaceQueryItem] {
    get {
      return MapzenSearchDataConverter.wrapQueryItems(peliasConfig.places)
    }
  }

  public init(places: [MzPlaceQueryItem], completionHandler: @escaping (MapzenResponse) -> Void) {
    let unwrappedPlaces = MapzenSearchDataConverter.unwrapQueryItems(places)
    peliasConfig = PeliasPlaceConfig(places: unwrappedPlaces, completionHandler: { (response) in
      let mapzenResponse = MapzenResponse.init(response)
      completionHandler(mapzenResponse)
    })
  }
}

public class MapzenReverseConfig : NSObject {

  var peliasConfig: PeliasReverseConfig

  public var point: MzGeoPoint {
    get {
      return MapzenSearchDataConverter.wrapPoint(peliasConfig.point)
    }
  }

  public var numberOfResults: Int? {
    get {
      return peliasConfig.numberOfResults
    }
    set {
      peliasConfig.numberOfResults = newValue
    }
  }

  public var boundaryCountry: String? {
    get {
      return peliasConfig.boundaryCountry
    }
    set {
      peliasConfig.boundaryCountry = newValue
    }
  }

  public var dataSources: [MzSearchSource]? {
    get {
      guard let sources = peliasConfig.dataSources else { return nil }
      return MapzenSearchDataConverter.wrapSearchSources(sources)
    }
    set {
      guard let sources = newValue else {
        peliasConfig.dataSources = nil
        return
      }
      peliasConfig.dataSources =  MapzenSearchDataConverter.unwrapSearchSources(sources)
    }
  }

  public var layers: [MzLayerFilter]? {
    get {
      guard let layers = peliasConfig.layers else { return nil }
      return MapzenSearchDataConverter.wrapLayerFilters(layers)
    }
    set {
      guard let layers = newValue else {
        peliasConfig.layers = nil
        return
      }
      peliasConfig.layers = MapzenSearchDataConverter.unwrapLayerFilters(layers)
    }
  }

  public init(point: MzGeoPoint, completionHandler: @escaping (MapzenResponse) -> Void) {
    let unwrappedPoint = MapzenSearchDataConverter.unwrapPoint(point)
    peliasConfig = PeliasReverseConfig(point: unwrappedPoint, completionHandler: { (peliasResponse) -> Void in
      let mapzenResponse = MapzenResponse.init(peliasResponse)
      completionHandler(mapzenResponse)
    })
  }
}

open class MapzenSearchConfig: NSObject {
  var peliasConfig: PeliasSearchConfig

  public var searchText: String {
    get {
      return peliasConfig.searchText;
    }
    set(text) {
      peliasConfig.searchText = text
    }
  }

  public var numberOfResults: Int? {
    get {
      return peliasConfig.numberOfResults
    }
    set(num) {
      peliasConfig.numberOfResults = num
    }
  }

  public var boundaryCountry: String? {
    get {
      return peliasConfig.boundaryCountry
    }
    set(text) {
      peliasConfig.boundaryCountry = text
    }
  }

  public var boundaryRect: MzSearchRect? {
    get {
      if let rect = peliasConfig.boundaryRect{
        return MzSearchRect(boundaryRect: rect)
      }
      return nil
    }
    set (rectWrapper) {
      peliasConfig.boundaryRect = rectWrapper?.rect
    }
  }

  public var boundaryCircle: MzSearchCircle? {
    get {
      if let circle = peliasConfig.boundaryCircle {
        return MzSearchCircle(boundaryCircle: circle)
      }
      return nil
    }
    set(circleWrapper) {
      peliasConfig.boundaryCircle = circleWrapper?.circle
    }
  }

  public var focusPoint: MzGeoPoint? {
    get {
      if let point = peliasConfig.focusPoint {
        return MzGeoPoint(geoPoint: point)
      }
      return nil
    }
    set(pointWrapper) {
      peliasConfig.focusPoint = pointWrapper?.point
    }
  }

  public var dataSources: [MzSearchSource]? {
    get {
      if let sources = peliasConfig.dataSources {
        return MapzenSearchDataConverter.wrapSearchSources(sources)
      }
      return nil
    }
    set {
      if let sources = newValue {
        peliasConfig.dataSources = MapzenSearchDataConverter.unwrapSearchSources(sources)
      }
    }
  }

  public var layers: [MzLayerFilter]? {
    get {
      if let layerArray = peliasConfig.layers {
        return MapzenSearchDataConverter.wrapLayerFilters(layerArray)
      }
      return nil
    }
    set {
      if let layerArray = newValue {
        peliasConfig.layers = MapzenSearchDataConverter.unwrapLayerFilters(layerArray)
      }
    }
  }

  public init(searchText: String, completionHandler: @escaping (MapzenResponse) -> Void) {
    peliasConfig = PeliasSearchConfig(searchText: searchText, completionHandler: { (peliasResponse) -> Void in
      let mapzenResponse = MapzenResponse.init(peliasResponse)
      completionHandler(mapzenResponse)
    })
  }
}

