//
//  MapzenReverseConfig.swift
//  Pods
//
//  Created by Sarah Lensing on 3/20/17.
//
//

import Foundation
import Pelias

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

