//
//  ReverseConfigTests.swift
//  ios-sdk
//
//  Created by Sarah Lensing on 3/21/17.
//  Copyright © 2017 Mapzen. All rights reserved.
//

import XCTest
@testable import ios_sdk

class ReverseConfigTests: XCTestCase {

  var config: ReverseConfig = ReverseConfig.init(point: GeoPoint.init(latitude: 70.0, longitude: 40.0), completionHandler: { (response) in })

  func testPointIsCorrect() {
    XCTAssertEqual(GeoPoint(latitude: 70.0, longitude: 40.0), config.point)
  }

  func testNumOfResults() {
    config.numberOfResults = 8
    XCTAssertEqual(8, config.numberOfResults)
  }

  func testBoundaryCountry() {
    config.boundaryCountry = "US"
    XCTAssertEqual("US", config.boundaryCountry)
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
