//
//  MapzenSearchConfig.swift
//  Pods
//
//  Created by Sarah Lensing on 3/20/17.
//
//

import Foundation
import Pelias

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
