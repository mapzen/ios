//
//  MapzenSearchTests.swift
//  ios-sdk
//
//  Created by Sarah Lensing on 3/28/17.
//  Copyright © 2017 Mapzen. All rights reserved.
//

import XCTest
@testable import MapzenSDK
import Pelias

public class MapzenSearchTests : XCTestCase {

  let mapzenSearch = MapzenSearch.sharedInstance
  let peliasSearchManager = PeliasSearchManager.sharedInstance

  func testAutocompleteTimeDelay() {
    mapzenSearch.autocompleteTimeDelay = 3
    XCTAssertEqual(3, mapzenSearch.autocompleteTimeDelay)
    XCTAssertEqual(3, peliasSearchManager.autocompleteTimeDelay)
  }

  func testBaseUrl() {
    let defaultBaseUrl = URL.init(string: Constants.URL.base)
    XCTAssertEqual(mapzenSearch.baseUrl, defaultBaseUrl)
    XCTAssertEqual(peliasSearchManager.baseUrl, defaultBaseUrl)

    let baseUrl = URL.init(string: "https://search.custom.com")!
    mapzenSearch.baseUrl = baseUrl
    XCTAssertEqual(mapzenSearch.baseUrl, baseUrl)
    XCTAssertEqual(peliasSearchManager.baseUrl, baseUrl)
  }

  func testQueryItems() {
    let items = [URLQueryItem.init(name: "test", value: "val")]
    mapzenSearch.urlQueryItems = items
    XCTAssertEqual(mapzenSearch.urlQueryItems!, items)
    XCTAssertEqual(peliasSearchManager.urlQueryItems!, items)
  }

  func testSearchQuery() {
    let config = SearchConfig.init(searchText: "test") { (response) in
      //
    }
    let operation = mapzenSearch.search(config)
    XCTAssertNotNil(operation)
  }

  func testReverseQuery() {
    let config = ReverseConfig.init(point: GeoPoint.init(latitude: 40, longitude: 40)) { (response) in
      //
    }
    let operation = mapzenSearch.reverseGeocode(config)
    XCTAssertNotNil(operation)
  }

  func testAutocompleteQuery() {
    let config = AutocompleteConfig.init(searchText: "test", focusPoint: GeoPoint.init(latitude: 40, longitude: 40)) { (response) in
      //
    }
    let operation = mapzenSearch.autocompleteQuery(config)
    XCTAssertNotNil(operation)
  }

  func testPlaceQuery() {
    let config = PlaceConfig.init(gids: [""]) { (response) in
      //
    }
    let operation = mapzenSearch.placeQuery(config)
    XCTAssertNotNil(operation)
  }
}
