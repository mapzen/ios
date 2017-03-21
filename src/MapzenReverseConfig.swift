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

  let peliasConfig: PeliasReverseConfig

  public var urlEndpoint: URL {
    get {
      return peliasConfig.urlEndpoint
    }
  }

  public var queryItems: [String:URLQueryItem] {
    get {
      return peliasConfig.queryItems
    }
  }

  public var point: MzGeoPoint {
    get {
      return MapzenSearchDataConverter.wrapPoint(peliasConfig.point)
    }
  }

  public var numberOfResults: Int? {
    get {
      return peliasConfig.numberOfResults
    }
  }

  public var boundaryCountry: String? {
    get {
      return peliasConfig.boundaryCountry
    }
  }

  public var dataSources: [MzSearchSource]? {
    get {
      guard let sources = peliasConfig.dataSources else { return nil }
      return MapzenSearchDataConverter.wrapSearchSources(sources)
    }
  }

  public var layers: [MzLayerFilter]? {
    get {
      guard let layers = peliasConfig.layers else { return nil }
      return MapzenSearchDataConverter.wrapLayerFilters(layers)
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

