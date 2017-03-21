//
//  MapzenAutocompleteConfig.swift
//  Pods
//
//  Created by Sarah Lensing on 3/20/17.
//
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

  public var urlEndpoint: URL {
    get {
      return peliasConfig.urlEndpoint
    }
  }

  public var searchText: String {
    get {
      return peliasConfig.searchText
    }
  }

  public var queryItems: [String:URLQueryItem] {
    get {
      return peliasConfig.queryItems
    }
  }

  public init(searchText: String, focusPoint: GeoPoint, completionHandler: @escaping (MapzenResponse) -> Void) {
    peliasConfig = PeliasAutocompleteConfig(searchText: searchText, focusPoint: focusPoint, completionHandler: { (response) in
      let mapzenResponse = MapzenResponse.init(response)
      completionHandler(mapzenResponse)
    })
  }
}
