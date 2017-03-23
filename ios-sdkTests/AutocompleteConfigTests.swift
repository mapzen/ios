//
//  PlaceConfigTests.swift
//  ios-sdk
//
//  Created by Sarah Lensing on 3/21/17.
//  Copyright © 2017 Mapzen. All rights reserved.
//

import XCTest
@testable import ios_sdk

class AutocompleteConfigTests: XCTestCase {

  var config: AutocompleteConfig = AutocompleteConfig.init(searchText: "test", focusPoint: GeoPoint.init(latitude: 70.0, longitude: 40.0), completionHandler: { (response) in })

  func testFocusPointIsCorrect() {
    XCTAssertEqual(GeoPoint(latitude: 70.0, longitude: 40.0), config.focusPoint)
  }

  func testSearchTestIsCorrect() {
    XCTAssertEqual("test", config.searchText)
  }

}
