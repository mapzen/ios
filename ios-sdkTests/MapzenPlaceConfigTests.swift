//
//  MapzenPlaceConfigTests.swift
//  ios-sdk
//
//  Created by Sarah Lensing on 3/21/17.
//  Copyright © 2017 Mapzen. All rights reserved.
//

import XCTest
@testable import ios_sdk

class MapzenPlaceConfigTests: XCTestCase {

  var config: MapzenPlaceConfig = MapzenPlaceConfig.init(places: [MzPlaceQueryItem.init(placeId: "123", dataSource: .openStreetMap, layer: .address)], completionHandler: { (response) in })

  func testPlacesAreCorrect() {
    XCTAssertEqual(config.places.count, 1)
    XCTAssertEqual(MzPlaceQueryItem.init(placeId: "123", dataSource: .openStreetMap, layer: .address), config.places.first)
  }
}
