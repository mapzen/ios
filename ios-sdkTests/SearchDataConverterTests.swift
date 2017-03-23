//
//  SearchDataConverterTests.swift
//  ios-sdk
//
//  Created by Sarah Lensing on 3/21/17.
//  Copyright © 2017 Mapzen. All rights reserved.
//

import XCTest
@testable import ios_sdk
import Pelias

class SearchDataConverterTests: XCTestCase {

  func testUnwrapSearchSources() {
    let sources = [SearchSource.geoNames, SearchSource.openAddresses, SearchSource.openStreetMap, SearchSource.quattroshapes]
    let unwrapped = SearchDataConverter.unwrapSearchSources(sources)
    XCTAssertTrue(unwrapped.contains(.GeoNames))
    XCTAssertTrue(unwrapped.contains(.OpenAddresses))
    XCTAssertTrue(unwrapped.contains(.OpenStreetMap))
    XCTAssertTrue(unwrapped.contains(.Quattroshapes))
    XCTAssertEqual(unwrapped.count, 4)
  }

  func testUnwrapSearchSource() {
    XCTAssertEqual(SearchDataConverter.unwrapSearchSource(.openStreetMap), .OpenStreetMap)
    XCTAssertEqual(SearchDataConverter.unwrapSearchSource(.openAddresses), .OpenAddresses)
    XCTAssertEqual(SearchDataConverter.unwrapSearchSource(.quattroshapes), .Quattroshapes)
    XCTAssertEqual(SearchDataConverter.unwrapSearchSource(.geoNames), .GeoNames)
  }

  func testWrapSearchSources() {
    let sources = [Pelias.SearchSource.GeoNames, Pelias.SearchSource.OpenAddresses, Pelias.SearchSource.OpenStreetMap, Pelias.SearchSource.Quattroshapes]
    let wrapped = SearchDataConverter.wrapSearchSources(sources)
    XCTAssertTrue(wrapped.contains(.geoNames))
    XCTAssertTrue(wrapped.contains(.openAddresses))
    XCTAssertTrue(wrapped.contains(.openStreetMap))
    XCTAssertTrue(wrapped.contains(.quattroshapes))
    XCTAssertEqual(wrapped.count, 4)

  }

  func testWrapSearchSource() {
    XCTAssertEqual(SearchDataConverter.wrapSearchSource(.OpenStreetMap), .openStreetMap)
    XCTAssertEqual(SearchDataConverter.wrapSearchSource(.OpenAddresses), .openAddresses)
    XCTAssertEqual(SearchDataConverter.wrapSearchSource(.Quattroshapes), .quattroshapes)
    XCTAssertEqual(SearchDataConverter.wrapSearchSource(.GeoNames), .geoNames)
  }

  func testUnwrapLayerFilters() {
    let layers = [ios_sdk.LayerFilter.venue, LayerFilter.address, LayerFilter.country, LayerFilter.region, LayerFilter.locality, LayerFilter.localadmin, LayerFilter.neighbourhood, LayerFilter.coarse]
    let unwrapped = SearchDataConverter.unwrapLayerFilters(layers)
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
    XCTAssertEqual(SearchDataConverter.unwrapLayerFilter(.venue), .venue)
    XCTAssertEqual(SearchDataConverter.unwrapLayerFilter(.address), .address)
    XCTAssertEqual(SearchDataConverter.unwrapLayerFilter(.country), .country)
    XCTAssertEqual(SearchDataConverter.unwrapLayerFilter(.region), .region)
    XCTAssertEqual(SearchDataConverter.unwrapLayerFilter(.locality), .locality)
    XCTAssertEqual(SearchDataConverter.unwrapLayerFilter(.localadmin), .localadmin)
    XCTAssertEqual(SearchDataConverter.unwrapLayerFilter(.neighbourhood), .neighbourhood)
    XCTAssertEqual(SearchDataConverter.unwrapLayerFilter(.coarse), .coarse)
  }

  func testWrapLayerFilters() {
    let layers = [Pelias.LayerFilter.venue, LayerFilter.address, LayerFilter.country, LayerFilter.region, LayerFilter.locality, LayerFilter.localadmin, LayerFilter.neighbourhood, LayerFilter.coarse]
    let wrapped = SearchDataConverter.wrapLayerFilters(layers)
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
    XCTAssertEqual(SearchDataConverter.wrapLayerFilter(.venue), .venue)
    XCTAssertEqual(SearchDataConverter.wrapLayerFilter(.address), .address)
    XCTAssertEqual(SearchDataConverter.wrapLayerFilter(.country), .country)
    XCTAssertEqual(SearchDataConverter.wrapLayerFilter(.region), .region)
    XCTAssertEqual(SearchDataConverter.wrapLayerFilter(.locality), .locality)
    XCTAssertEqual(SearchDataConverter.wrapLayerFilter(.localadmin), .localadmin)
    XCTAssertEqual(SearchDataConverter.wrapLayerFilter(.neighbourhood), .neighbourhood)
    XCTAssertEqual(SearchDataConverter.wrapLayerFilter(.coarse), .coarse)
  }

  func testWrapPoint() {
    let point = Pelias.GeoPoint(latitude: 70.0, longitude: 40.0)
    let wrapped = SearchDataConverter.wrapPoint(point)
    XCTAssertEqual(point, wrapped.point)
  }

  func testUnwrapPoint() {
    let point = ios_sdk.GeoPoint(latitude: 70.0, longitude: 40.0)
    let unwrapped = SearchDataConverter.unwrapPoint(point)
    XCTAssertEqual(point.point, unwrapped)
  }

  func testUnwrapQueryItems() {
    let items = [PlaceQueryItem.init(placeId: "id", dataSource: .geoNames, layer: .address),
                 PlaceQueryItem.init(placeId: "anotherid", dataSource: .quattroshapes, layer: .region)]
    let unwrapped = SearchDataConverter.unwrapQueryItems(items)
    XCTAssertEqual(unwrapped[0].placeId, "id")
    XCTAssertEqual(unwrapped[0].dataSource, .GeoNames)
    XCTAssertEqual(unwrapped[0].layer, .address)
    XCTAssertEqual(unwrapped[1].placeId, "anotherid")
    XCTAssertEqual(unwrapped[1].dataSource, .Quattroshapes)
    XCTAssertEqual(unwrapped[1].layer, .region)
    XCTAssertEqual(unwrapped.count, 2)
  }

  func testUnwrapQueryItem() {
    let item = PlaceQueryItem.init(placeId: "id", dataSource: .openStreetMap, layer: .venue)
    let unwrapped = SearchDataConverter.unwrapQueryItem(item)
    XCTAssertEqual(unwrapped.placeId, "id")
    XCTAssertEqual(unwrapped.dataSource, .OpenStreetMap)
    XCTAssertEqual(unwrapped.layer, .venue)
  }

  func testWrapQueryItems() {
    let items = [PeliasPlaceQueryItem.init(placeId: "id", dataSource: .GeoNames, layer: .address),
                 PeliasPlaceQueryItem.init(placeId: "anotherid", dataSource: .Quattroshapes, layer: .region)]
    let wrapped = SearchDataConverter.wrapQueryItems(items)
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
    let wrapped = SearchDataConverter.wrapQueryItem(item)
    XCTAssertEqual(wrapped.placeId, "id")
    XCTAssertEqual(wrapped.dataSource, .openStreetMap)
    XCTAssertEqual(wrapped.layer, .venue)
  }

}
