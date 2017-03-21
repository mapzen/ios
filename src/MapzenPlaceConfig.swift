//
//  MapzenPlaceConfig.swift
//  Pods
//
//  Created by Sarah Lensing on 3/20/17.
//
//

import Foundation
import Pelias

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
