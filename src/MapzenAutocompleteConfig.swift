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
