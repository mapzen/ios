//
//  SearchConfigs.swift
//  ios-sdk
//
//  Created by Sarah Lensing on 3/23/17.
//  Copyright © 2017 Mapzen. All rights reserved.
//

import Foundation
import Pelias

/// Encapsulates request parameters for autocomplete requests.
@objc(MZAutocompleteConfig)
public class AutocompleteConfig : NSObject {
  let peliasConfig : PeliasAutocompleteConfig
  /// Text to search for within components of the location. This value is required to execute an autocomplete request.
  public var searchText: String {
    get {
      return peliasConfig.searchText
    }
  }
  /// Optional point to order results by where results closer to this value are returned higher in the list.
  public var focusPoint: GeoPoint {
    get {
      return SearchDataConverter.wrapPoint(peliasConfig.focusPoint)
    }
  }
  /**
   Initialize an autocomplete config with all the required parameters and a focus point.

   - parameter searchText: Text to search for within components of the location.
   - parameter focusPoint:  The point to order results around where results closer to this value are returned higher in the list.
   - parameter completionHandler: The closure to execute when the request suceeds or fails.
   */
  public init(searchText: String, focusPoint: GeoPoint, completionHandler: @escaping (SearchResponse) -> Void) {
    let unwrappedPoint = SearchDataConverter.unwrapPoint(focusPoint)
    peliasConfig = PeliasAutocompleteConfig(searchText: searchText, focusPoint: unwrappedPoint, completionHandler: { (response) in
      let mapzenResponse = SearchResponse.init(response)
      completionHandler(mapzenResponse)
    })
  }
}
/// Encapsulates request parameters for place requests.
@objc(MZPlaceConfig)
public class PlaceConfig : NSObject {
  var peliasConfig: PeliasPlaceConfig
  /// The place gids to fetch info for.
  public var gids: [String] {
    set {
      peliasConfig.gids = newValue
    }
    get {
      return peliasConfig.gids
    }
  }

  /**
   Initialize a place config with all the required parameters.

   - parameter gids: The place gids to request info for.
   - parameter completionHandler: The closure to execute when the request suceeds or fails.
   */
  public init(gids: [String], completionHandler: @escaping (SearchResponse) -> Void) {
    peliasConfig = PeliasPlaceConfig(gids: gids, completionHandler: { (response) in
      let mapzenResponse = SearchResponse.init(response)
      completionHandler(mapzenResponse)
    })
  }
}
/// Encapsulates request parameters for reverse geo requests.
@objc(MZReverseConfig)
public class ReverseConfig : NSObject {

  var peliasConfig: PeliasReverseConfig
  /// The point to reverse geocode. This value is required.
  public var point: GeoPoint {
    get {
      return SearchDataConverter.wrapPoint(peliasConfig.point)
    }
  }
  /// The number of results to return. This value is optional and will default to 10 if no value is defined.
  public var numberOfResults: Int? {
    get {
      return peliasConfig.numberOfResults
    }
    set {
      peliasConfig.numberOfResults = newValue
    }
  }
  /// The boundary country (in ISO-3166 alpha-2 or alpha-3 format) to limit results by. This value is optional and defaults to not restricting results to any country.
  public var boundaryCountry: String? {
    get {
      return peliasConfig.boundaryCountry
    }
    set {
      peliasConfig.boundaryCountry = newValue
    }
  }
  /// Sources to fetch data from. This value is optional and defaults to all sources.
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
  /// Layers to fetch sources from. This value is optional and defaults to all sources.
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
  /**
   Initialize a reverse config with all the required parameters.

   - parameter point: The point to reverse geocode.
   - parameter completionHandler: The closure to execute when the request suceeds or fails.
   */
  public init(point: GeoPoint, completionHandler: @escaping (SearchResponse) -> Void) {
    let unwrappedPoint = SearchDataConverter.unwrapPoint(point)
    peliasConfig = PeliasReverseConfig(point: unwrappedPoint, completionHandler: { (peliasResponse) -> Void in
      let mapzenResponse = SearchResponse.init(peliasResponse)
      completionHandler(mapzenResponse)
    })
  }
}
/// Encapsulates request parameters for search requests.
@objc(MZSearchConfig)
open class SearchConfig: NSObject {
  var peliasConfig: PeliasSearchConfig
  /// Text to search for within components of the location. This value is required.
  public var searchText: String {
    get {
      return peliasConfig.searchText;
    }
    set(text) {
      peliasConfig.searchText = text
    }
  }
  /// The number of results to return. This value is optional and defaults to 10.
  public var numberOfResults: Int? {
    get {
      return peliasConfig.numberOfResults
    }
    set(num) {
      peliasConfig.numberOfResults = num
    }
  }
  /// The boundary country (in ISO-3166 alpha-2 or alpha-3 format) to limit results by. This value is optional and defaults to not restricting results to any country.
  public var boundaryCountry: String? {
    get {
      return peliasConfig.boundaryCountry
    }
    set(text) {
      peliasConfig.boundaryCountry = text
    }
  }
  /// The rectangular boundary to limit results to. This value is optional and defaults to none.
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
  /// The circular boundary to limit results to. This value is optional and defaults to none.
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
  /// The point to order results by where results closer to this value are returned higher in the list. This value is optional and defaults to none.
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
  /// Sources to fetch data from. This value is optional and defaults to all sources.
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
  /// Layers to fetch sources from. This value is optional and defaults to all sources.
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
  /**
   Initialize a search config with all the required parameters. This value will get converted into the appropriate query item.

   - parameter searchText: Text to search for within components of the location.
   - parameter completionHandler: The closure to execute when the request suceeds or fails.
   */
  public init(searchText: String, completionHandler: @escaping (SearchResponse) -> Void) {
    peliasConfig = PeliasSearchConfig(searchText: searchText, completionHandler: { (peliasResponse) -> Void in
      let mapzenResponse = SearchResponse.init(peliasResponse)
      completionHandler(mapzenResponse)
    })
  }
}
