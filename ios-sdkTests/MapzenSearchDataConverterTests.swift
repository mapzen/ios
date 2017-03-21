//
//  MapzenSearchDataConverterTests.swift
//  ios-sdk
//
//  Created by Sarah Lensing on 3/21/17.
//  Copyright © 2017 Mapzen. All rights reserved.
//

import XCTest
@testable import ios_sdk
import Pelias

class MapzenSearchDataConverterTests: XCTestCase {

  func testUnwrapSearchSources() {
    let sources = [MzSearchSource.geoNames, MzSearchSource.openAddresses, MzSearchSource.openStreetMap, MzSearchSource.quattroshapes]
    let unwrapped = MapzenSearchDataConverter.unwrapSearchSources(sources)
    XCTAssertTrue(unwrapped.contains(.GeoNames))
    XCTAssertTrue(unwrapped.contains(.OpenAddresses))
    XCTAssertTrue(unwrapped.contains(.OpenStreetMap))
    XCTAssertTrue(unwrapped.contains(.Quattroshapes))
    XCTAssertEqual(unwrapped.count, 4)
  }

  func testUnwrapSearchSource() {
    XCTAssertEqual(MapzenSearchDataConverter.unwrapSearchSource(.openStreetMap), .OpenStreetMap)
    XCTAssertEqual(MapzenSearchDataConverter.unwrapSearchSource(.openAddresses), .OpenAddresses)
    XCTAssertEqual(MapzenSearchDataConverter.unwrapSearchSource(.quattroshapes), .Quattroshapes)
    XCTAssertEqual(MapzenSearchDataConverter.unwrapSearchSource(.geoNames), .GeoNames)
  }

  func testWrapSearchSources() {
    let sources = [SearchSource.GeoNames, SearchSource.OpenAddresses, SearchSource.OpenStreetMap, SearchSource.Quattroshapes]
    let wrapped = MapzenSearchDataConverter.wrapSearchSources(sources)
    XCTAssertTrue(wrapped.contains(.geoNames))
    XCTAssertTrue(wrapped.contains(.openAddresses))
    XCTAssertTrue(wrapped.contains(.openStreetMap))
    XCTAssertTrue(wrapped.contains(.quattroshapes))
    XCTAssertEqual(wrapped.count, 4)

  }

  func testWrapSearchSource() {
    XCTAssertEqual(MapzenSearchDataConverter.wrapSearchSource(.OpenStreetMap), .openStreetMap)
    XCTAssertEqual(MapzenSearchDataConverter.wrapSearchSource(.OpenAddresses), .openAddresses)
    XCTAssertEqual(MapzenSearchDataConverter.wrapSearchSource(.Quattroshapes), .quattroshapes)
    XCTAssertEqual(MapzenSearchDataConverter.wrapSearchSource(.GeoNames), .geoNames)
  }

  func testUnwrapLayerFilters() {
    let layers = [MzLayerFilter.venue, MzLayerFilter.address, MzLayerFilter.country, MzLayerFilter.region, MzLayerFilter.locality, MzLayerFilter.localadmin, MzLayerFilter.neighbourhood, MzLayerFilter.coarse]
    let unwrapped = MapzenSearchDataConverter.unwrapLayerFilters(layers)
    XCTAssertTrue(unwrapped.contains(.venue))
    XCTAssertTrue(unwrapped.contains(.address))
    XCTAssertTrue(unwrapped.contains(.country))
    XCTAssertTrue(unwrapped.contains(.region))
    XCTAssertTrue(unwrapped.contains(.locality))
    XCTAssertTrue(unwrapped.contains(.localadmin))
    XCTAssertTrue(unwrapped.contains(.neighbourhood))
    XCTAssertTrue(unwrapped.contains(.coarse))
    XCTAssertEqual(unwrapped.count, 8)
  }

  func testUnwrapLayerFilter() {
    XCTAssertEqual(MapzenSearchDataConverter.unwrapLayerFilter(.venue), .venue)
    XCTAssertEqual(MapzenSearchDataConverter.unwrapLayerFilter(.address), .address)
    XCTAssertEqual(MapzenSearchDataConverter.unwrapLayerFilter(.country), .country)
    XCTAssertEqual(MapzenSearchDataConverter.unwrapLayerFilter(.region), .region)
    XCTAssertEqual(MapzenSearchDataConverter.unwrapLayerFilter(.locality), .locality)
    XCTAssertEqual(MapzenSearchDataConverter.unwrapLayerFilter(.localadmin), .localadmin)
    XCTAssertEqual(MapzenSearchDataConverter.unwrapLayerFilter(.neighbourhood), .neighbourhood)
    XCTAssertEqual(MapzenSearchDataConverter.unwrapLayerFilter(.coarse), .coarse)
  }

  func testWrapLayerFilters() {
    let layers = [LayerFilter.venue, LayerFilter.address, LayerFilter.country, LayerFilter.region, LayerFilter.locality, LayerFilter.localadmin, LayerFilter.neighbourhood, LayerFilter.coarse]
    let wrapped = MapzenSearchDataConverter.wrapLayerFilters(layers)
    XCTAssertTrue(wrapped.contains(.venue))
    XCTAssertTrue(wrapped.contains(.address))
    XCTAssertTrue(wrapped.contains(.country))
    XCTAssertTrue(wrapped.contains(.region))
    XCTAssertTrue(wrapped.contains(.locality))
    XCTAssertTrue(wrapped.contains(.localadmin))
    XCTAssertTrue(wrapped.contains(.neighbourhood))
    XCTAssertTrue(wrapped.contains(.coarse))
    XCTAssertEqual(wrapped.count, 8)
  }

  func testWrapLayerFilter() {
    XCTAssertEqual(MapzenSearchDataConverter.wrapLayerFilter(.venue), .venue)
    XCTAssertEqual(MapzenSearchDataConverter.wrapLayerFilter(.address), .address)
    XCTAssertEqual(MapzenSearchDataConverter.wrapLayerFilter(.country), .country)
    XCTAssertEqual(MapzenSearchDataConverter.wrapLayerFilter(.region), .region)
    XCTAssertEqual(MapzenSearchDataConverter.wrapLayerFilter(.locality), .locality)
    XCTAssertEqual(MapzenSearchDataConverter.wrapLayerFilter(.localadmin), .localadmin)
    XCTAssertEqual(MapzenSearchDataConverter.wrapLayerFilter(.neighbourhood), .neighbourhood)
    XCTAssertEqual(MapzenSearchDataConverter.wrapLayerFilter(.coarse), .coarse)
  }

  func testWrapPoint() {
    let point = GeoPoint(latitude: 70.0, longitude: 40.0)
    let wrapped = MapzenSearchDataConverter.wrapPoint(point)
    XCTAssertEqual(point, wrapped.point)
  }

  func testUnwrapPoint() {
    let point = MzGeoPoint(latitude: 70.0, longitude: 40.0)
    let unwrapped = MapzenSearchDataConverter.unwrapPoint(point)
    XCTAssertEqual(point.point, unwrapped)
  }

  func testUnwrapQueryItems() {
    let items = [MzPlaceQueryItem.init(placeId: "id", dataSource: .geoNames, layer: .address),
                 MzPlaceQueryItem.init(placeId: "anotherid", dataSource: .quattroshapes, layer: .region)]
    let unwrapped = MapzenSearchDataConverter.unwrapQueryItems(items)
    XCTAssertEqual(unwrapped[0].placeId, "id")
    XCTAssertEqual(unwrapped[0].dataSource, .GeoNames)
    XCTAssertEqual(unwrapped[0].layer, .address)
    XCTAssertEqual(unwrapped[1].placeId, "anotherid")
    XCTAssertEqual(unwrapped[1].dataSource, .Quattroshapes)
    XCTAssertEqual(unwrapped[1].layer, .region)
    XCTAssertEqual(unwrapped.count, 2)
  }

  func testUnwrapQueryItem() {
    let item = MzPlaceQueryItem.init(placeId: "id", dataSource: .openStreetMap, layer: .venue)
    let unwrapped = MapzenSearchDataConverter.unwrapQueryItem(item)
    XCTAssertEqual(unwrapped.placeId, "id")
    XCTAssertEqual(unwrapped.dataSource, .OpenStreetMap)
    XCTAssertEqual(unwrapped.layer, .venue)
  }

  func testWrapQueryItems() {
    let items = [PeliasPlaceQueryItem.init(placeId: "id", dataSource: .GeoNames, layer: .address),
                 PeliasPlaceQueryItem.init(placeId: "anotherid", dataSource: .Quattroshapes, layer: .region)]
    let wrapped = MapzenSearchDataConverter.wrapQueryItems(items)
    XCTAssertEqual(wrapped[0].placeId, "id")
    XCTAssertEqual(wrapped[0].dataSource, .geoNames)
    XCTAssertEqual(wrapped[0].layer, .address)
    XCTAssertEqual(wrapped[1].placeId, "anotherid")
    XCTAssertEqual(wrapped[1].dataSource, .quattroshapes)
    XCTAssertEqual(wrapped[1].layer, .region)
    XCTAssertEqual(wrapped.count, 2)
  }

  func testWrapQueryItem() {
    let item = PeliasPlaceQueryItem.init(placeId: "id", dataSource: .OpenStreetMap, layer: .venue)
    let wrapped = MapzenSearchDataConverter.wrapQueryItem(item)
    XCTAssertEqual(wrapped.placeId, "id")
    XCTAssertEqual(wrapped.dataSource, .openStreetMap)
    XCTAssertEqual(wrapped.layer, .venue)
  }

}
