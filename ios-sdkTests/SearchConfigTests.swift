//
//  SearchConfigTests.swift
//  ios-sdk
//
//  Created by Sarah Lensing on 3/21/17.
//  Copyright © 2017 Mapzen. All rights reserved.
//

import XCTest
@testable import ios_sdk

class SearchConfigTests: XCTestCase {

  var config: SearchConfig = SearchConfig.init(searchText: "test", completionHandler: { (response) in })

  func testSearchTextIsCorrect() {
    XCTAssertEqual("test", config.searchText)
  }

  func testNumOfResults() {
    config.numberOfResults = 8
    XCTAssertEqual(8, config.numberOfResults)
  }

  func testBoundaryCountry() {
    config.boundaryCountry = "US"
    XCTAssertEqual("US", config.boundaryCountry)
  }

  func testBoundaryRect() {
    let rect = SearchRect(minLatLong: GeoPoint(latitude: 70.0, longitude: 40.0), maxLatLong: GeoPoint(latitude: 75.0, longitude: 40.0))
    config.boundaryRect = rect
    XCTAssertEqual(rect, config.boundaryRect)
  }

  func testBoundaryCircle() {
    let circle = SearchCircle(center: GeoPoint(latitude: 70.0, longitude: 40.0), radius: 10)
    config.boundaryCircle = circle
    XCTAssertEqual(circle, config.boundaryCircle)
  }

  func testFocusPoint() {
    let point = GeoPoint(latitude: 70.0, longitude: 40.0)
    config.focusPoint = point
    XCTAssertEqual(point, config.focusPoint)
  }

  func testDataSources() {
    config.dataSources = [.geoNames, .openAddresses]
    XCTAssertEqual([.geoNames, .openAddresses], config.dataSources!)
  }

  func testLayers() {
    config.layers = [.address, .country]
    XCTAssertEqual([.address, .country], config.layers!)
  }
}
