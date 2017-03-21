//
//  MapzenSearchDataConverter.swift
//  Pods
//
//  Created by Sarah Lensing on 3/20/17.
//
//

import Foundation
import Pelias

class MapzenSearchDataConverter {

  static func unwrapSearchSources(_ sources: [MzSearchSource]) -> [SearchSource] {
    var newSources: [SearchSource] = []
    for wrapper in sources {
      newSources.append(unwrapSearchSource(wrapper))
    }
    return newSources
  }

  static func unwrapSearchSource(_ source: MzSearchSource) -> SearchSource {
    switch source {
    case .openStreetMap:
      return SearchSource.OpenStreetMap
    case .openAddresses:
      return SearchSource.OpenAddresses
    case .quattroshapes:
      return SearchSource.Quattroshapes
    case.geoNames:
      return SearchSource.GeoNames
    }
  }

  static func wrapSearchSources(_ sources: [SearchSource]) -> [MzSearchSource] {
    var newSources: [MzSearchSource] = []
    for wrapper in sources {
      newSources.append(wrapSearchSource(wrapper))
    }
    return newSources
  }

  static func wrapSearchSource(_ source: SearchSource) -> MzSearchSource {
    switch source {
    case .OpenStreetMap:
      return MzSearchSource.openStreetMap
    case .OpenAddresses:
      return MzSearchSource.openAddresses
    case .Quattroshapes:
      return MzSearchSource.quattroshapes
    case.GeoNames:
      return MzSearchSource.geoNames
    }
  }

  static func unwrapLayerFilters(_ layers: [MzLayerFilter]) -> [LayerFilter] {
    var newLayers: [LayerFilter] = []
    for wrapper in layers {
      newLayers.append(unwrapLayerFilter(wrapper))
    }
    return newLayers
  }

  static func unwrapLayerFilter(_ layer: MzLayerFilter) -> LayerFilter {
    switch layer {
    case .address:
      return LayerFilter.address
    case .coarse:
      return LayerFilter.coarse
    case .country:
      return LayerFilter.country
    case .county:
      return LayerFilter.county
    case .localadmin:
      return LayerFilter.localadmin
    case .locality:
      return LayerFilter.locality
    case .neighbourhood:
      return LayerFilter.neighbourhood
    case .region:
      return LayerFilter.region
    case .venue:
      return LayerFilter.venue
    }
  }

  static func wrapLayerFilters(_ layers: [LayerFilter]) -> [MzLayerFilter] {
    var newLayers: [MzLayerFilter] = []
    for wrapper in layers {
      newLayers.append(wrapLayerFilter(wrapper))
    }
    return newLayers
  }

  static func wrapLayerFilter(_ layer: LayerFilter) -> MzLayerFilter {
    switch layer {
    case .address:
      return MzLayerFilter.address
    case .coarse:
      return MzLayerFilter.coarse
    case .country:
      return MzLayerFilter.country
    case .county:
      return MzLayerFilter.county
    case .localadmin:
      return MzLayerFilter.localadmin
    case .locality:
      return MzLayerFilter.locality
    case .neighbourhood:
      return MzLayerFilter.neighbourhood
    case .region:
      return MzLayerFilter.region
    case .venue:
      return MzLayerFilter.venue
    }
  }

  static func wrapPoint(_ point: GeoPoint) -> MzGeoPoint {
    return MzGeoPoint(geoPoint: point)
  }

  static func unwrapPoint(_ point: MzGeoPoint) -> GeoPoint {
    return point.point
  }

  static func unwrapQueryItems(_ items: [MzPlaceQueryItem]) -> [PeliasPlaceQueryItem] {
    var newItems: [PeliasPlaceQueryItem] = []
    for wrapper in items {
      newItems.append(unwrapQueryItem(wrapper))
    }
    return newItems
  }

  static func unwrapQueryItem(_ item: MzPlaceQueryItem) -> PeliasPlaceQueryItem {
    let unwrappedSource = unwrapSearchSource(item.dataSource)
    let unwrappedLayer = unwrapLayerFilter(item.layer)
    return PeliasPlaceQueryItem(placeId: item.placeId, dataSource: unwrappedSource, layer: unwrappedLayer)
  }

  static func wrapQueryItems(_ items: [PlaceAPIQueryItem]) -> [MzPlaceQueryItem] {
    var newItems: [MzPlaceQueryItem] = []
    for wrapper in items {
      newItems.append(wrapQueryItem(wrapper))
    }
    return newItems
  }

  static func wrapQueryItem(_ item: PlaceAPIQueryItem) -> MzPlaceQueryItem {
    let wrappedSource = wrapSearchSource(item.dataSource)
    let wrappedLayer = wrapLayerFilter(item.layer)
    return MzPlaceQueryItem(placeId: item.placeId, dataSource: wrappedSource, layer: wrappedLayer)
  }
}
