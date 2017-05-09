//
//  SearchDataConverter.swift
//  ios-sdk
//
//  Created by Sarah Lensing on 3/20/17.
//
//

import Foundation
import Pelias

/// Handles converting internal Pelias structs to their cooresponding Mapzen Search objects.
class SearchDataConverter {

  static func unwrapSearchSources(_ sources: [SearchSource]) -> [Pelias.SearchSource] {
    var newSources: [Pelias.SearchSource] = []
    for wrapper in sources {
      newSources.append(unwrapSearchSource(wrapper))
    }
    return newSources
  }

  static func unwrapSearchSource(_ source: SearchSource) -> Pelias.SearchSource {
    switch source {
    case .openStreetMap:
      return Pelias.SearchSource.OpenStreetMap
    case .openAddresses:
      return Pelias.SearchSource.OpenAddresses
    case .quattroshapes:
      return Pelias.SearchSource.Quattroshapes
    case.geoNames:
      return Pelias.SearchSource.GeoNames
    }
  }

  static func wrapSearchSources(_ sources: [Pelias.SearchSource]) -> [SearchSource] {
    var newSources: [SearchSource] = []
    for wrapper in sources {
      newSources.append(wrapSearchSource(wrapper))
    }
    return newSources
  }

  static func wrapSearchSource(_ source: Pelias.SearchSource) -> SearchSource {
    switch source {
    case Pelias.SearchSource.OpenStreetMap:
      return SearchSource.openStreetMap
    case Pelias.SearchSource.OpenAddresses:
      return SearchSource.openAddresses
    case Pelias.SearchSource.Quattroshapes:
      return SearchSource.quattroshapes
    case Pelias.SearchSource.GeoNames:
      return SearchSource.geoNames
    }
  }

  static func unwrapLayerFilters(_ layers: [LayerFilter]) -> [Pelias.LayerFilter] {
    var newLayers: [Pelias.LayerFilter] = []
    for wrapper in layers {
      newLayers.append(unwrapLayerFilter(wrapper))
    }
    return newLayers
  }

  static func unwrapLayerFilter(_ layer: LayerFilter) -> Pelias.LayerFilter {
    switch layer {
    case .address:
      return Pelias.LayerFilter.address
    case .coarse:
      return Pelias.LayerFilter.coarse
    case .country:
      return Pelias.LayerFilter.country
    case .county:
      return Pelias.LayerFilter.county
    case .localadmin:
      return Pelias.LayerFilter.localadmin
    case .locality:
      return Pelias.LayerFilter.locality
    case .neighbourhood:
      return Pelias.LayerFilter.neighbourhood
    case .region:
      return Pelias.LayerFilter.region
    case .venue:
      return Pelias.LayerFilter.venue
    }
  }

  static func wrapLayerFilters(_ layers: [Pelias.LayerFilter]) -> [LayerFilter] {
    var newLayers: [LayerFilter] = []
    for wrapper in layers {
      newLayers.append(wrapLayerFilter(wrapper))
    }
    return newLayers
  }

  static func wrapLayerFilter(_ layer: Pelias.LayerFilter) -> LayerFilter {
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

  static func wrapPoint(_ point: Pelias.GeoPoint) -> GeoPoint {
    return GeoPoint(geoPoint: point)
  }

  static func unwrapPoint(_ point: GeoPoint) -> Pelias.GeoPoint {
    return point.point
  }

}
