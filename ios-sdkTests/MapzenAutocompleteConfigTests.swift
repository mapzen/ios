//
//  MapzenAutocompleteConfigTests.swift
//  ios-sdk
//
//  Created by Sarah Lensing on 3/21/17.
//  Copyright © 2017 Mapzen. All rights reserved.
//

import XCTest
@testable import ios_sdk

class MapzenAutocompleteConfigTests: XCTestCase {

  var config: MapzenAutocompleteConfig = MapzenAutocompleteConfig.init(searchText: "test", focusPoint: MzGeoPoint.init(latitude: 70.0, longitude: 40.0), completionHandler: { (response) in })

  func testFocusPointIsCorrect() {
    XCTAssertEqual(MzGeoPoint(latitude: 70.0, longitude: 40.0), config.focusPoint)
  }

  func testSearchTestIsCorrect() {
    XCTAssertEqual("test", config.searchText)
  }

}
