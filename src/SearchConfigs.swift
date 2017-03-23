//
//  SearchConfigs.swift
//  ios-sdk
//
//  Created by Sarah Lensing on 3/23/17.
//  Copyright © 2017 Mapzen. All rights reserved.
//

import Foundation
import Pelias

@objc(MZAutocompleteConfig)
public class AutocompleteConfig : NSObject {
  let peliasConfig : PeliasAutocompleteConfig

  public var focusPoint: GeoPoint {
    get {
      return SearchDataConverter.wrapPoint(peliasConfig.focusPoint)
    }
  }

  public var searchText: String {
    get {
      return peliasConfig.searchText
    }
  }

  public init(searchText: String, focusPoint: GeoPoint, completionHandler: @escaping (SearchResponse) -> Void) {
    let unwrappedPoint = SearchDataConverter.unwrapPoint(focusPoint)
    peliasConfig = PeliasAutocompleteConfig(searchText: searchText, focusPoint: unwrappedPoint, completionHandler: { (response) in
      let mapzenResponse = SearchResponse.init(response)
      completionHandler(mapzenResponse)
    })
  }
}

@objc(MZPlaceConfig)
public class PlaceConfig : NSObject {
  let peliasConfig: PeliasPlaceConfig

  public var places: [PlaceQueryItem] {
    get {
      return SearchDataConverter.wrapQueryItems(peliasConfig.places)
    }
  }

  public init(places: [PlaceQueryItem], completionHandler: @escaping (SearchResponse) -> Void) {
    let unwrappedPlaces = SearchDataConverter.unwrapQueryItems(places)
    peliasConfig = PeliasPlaceConfig(places: unwrappedPlaces, completionHandler: { (response) in
      let mapzenResponse = SearchResponse.init(response)
      completionHandler(mapzenResponse)
    })
  }
}

@objc(MZReverseConfig)
public class ReverseConfig : NSObject {

  var peliasConfig: PeliasReverseConfig

  public var point: GeoPoint {
    get {
      return SearchDataConverter.wrapPoint(peliasConfig.point)
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

  public var dataSources: [SearchSource]? {
    get {
      guard let sources = peliasConfig.dataSources else { return nil }
      return SearchDataConverter.wrapSearchSources(sources)
    }
    set {
      guard let sources = newValue else {
        peliasConfig.dataSources = nil
        return
      }
      peliasConfig.dataSources =  SearchDataConverter.unwrapSearchSources(sources)
    }
  }

  public var layers: [LayerFilter]? {
    get {
      guard let layers = peliasConfig.layers else { return nil }
      return SearchDataConverter.wrapLayerFilters(layers)
    }
    set {
      guard let layers = newValue else {
        peliasConfig.layers = nil
        return
      }
      peliasConfig.layers = SearchDataConverter.unwrapLayerFilters(layers)
    }
  }

  public init(point: GeoPoint, completionHandler: @escaping (SearchResponse) -> Void) {
    let unwrappedPoint = SearchDataConverter.unwrapPoint(point)
    peliasConfig = PeliasReverseConfig(point: unwrappedPoint, completionHandler: { (peliasResponse) -> Void in
      let mapzenResponse = SearchResponse.init(peliasResponse)
      completionHandler(mapzenResponse)
    })
  }
}

@objc(MZSearchConfig)
open class SearchConfig: NSObject {
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

  public var boundaryRect: SearchRect? {
    get {
      if let rect = peliasConfig.boundaryRect{
        return SearchRect(boundaryRect: rect)
      }
      return nil
    }
    set (rectWrapper) {
      peliasConfig.boundaryRect = rectWrapper?.rect
    }
  }

  public var boundaryCircle: SearchCircle? {
    get {
      if let circle = peliasConfig.boundaryCircle {
        return SearchCircle(boundaryCircle: circle)
      }
      return nil
    }
    set(circleWrapper) {
      peliasConfig.boundaryCircle = circleWrapper?.circle
    }
  }

  public var focusPoint: GeoPoint? {
    get {
      if let point = peliasConfig.focusPoint {
        return GeoPoint(geoPoint: point)
      }
      return nil
    }
    set(pointWrapper) {
      peliasConfig.focusPoint = pointWrapper?.point
    }
  }

  public var dataSources: [SearchSource]? {
    get {
      if let sources = peliasConfig.dataSources {
        return SearchDataConverter.wrapSearchSources(sources)
      }
      return nil
    }
    set {
      if let sources = newValue {
        peliasConfig.dataSources = SearchDataConverter.unwrapSearchSources(sources)
      }
    }
  }

  public var layers: [LayerFilter]? {
    get {
      if let layerArray = peliasConfig.layers {
        return SearchDataConverter.wrapLayerFilters(layerArray)
      }
      return nil
    }
    set {
      if let layerArray = newValue {
        peliasConfig.layers = SearchDataConverter.unwrapLayerFilters(layerArray)
      }
    }
  }

  public init(searchText: String, completionHandler: @escaping (SearchResponse) -> Void) {
    peliasConfig = PeliasSearchConfig(searchText: searchText, completionHandler: { (peliasResponse) -> Void in
      let mapzenResponse = SearchResponse.init(peliasResponse)
      completionHandler(mapzenResponse)
    })
  }
}

