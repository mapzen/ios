//
//  MapzenManagerTests.swift
//  ios-sdk
//
//  Created by Matt Smollinger on 1/12/17.
//  Copyright © 2017 Mapzen. All rights reserved.
//

import XCTest
@testable import MapzenSDK
import Pelias


class MapzenManagerTests: XCTestCase {
  func testSingleton() {
    XCTAssertTrue(MapzenManager.sharedManager == MapzenManager.sharedManager)
  }

  func testApiKeyMapNotSet() {
    //Setup
    MapzenManager.sharedManager.apiKey = nil
    let map = MZMapViewController()

    XCTAssertThrowsError(try map.loadStyle(.bubbleWrap)) { (error) -> Void in
      let error = error as NSError
      XCTAssertTrue(error.code == MZError.apiKeyNotSet.rawValue)
    }
  }

  func testApiKeyMapSet() {
    //Setup
    MapzenManager.sharedManager.apiKey = "1234"
    let map = MZMapViewController()

    //Tests
    do {
      try map.loadStyle(.bubbleWrap)
    } catch {
      XCTFail()
    }
  }

  func testApiKeyRouteNotSet() {
    //Setup
    MapzenManager.sharedManager.apiKey = nil

    //Tests
    XCTAssertThrowsError(try RoutingController.controller()) { (error) -> Void in
      let error = error as NSError
      XCTAssertTrue(error.code == MZError.apiKeyNotSet.rawValue)
    }
  }

  func testApiKeyRouteSet () {
    //Setup
    MapzenManager.sharedManager.apiKey = "1234"

    //Tests
    do {
      let _ = try RoutingController.controller()
    } catch {
      XCTFail()
    }
  }

  func testApiKeySearch() {
    //Setup
    MapzenManager.sharedManager.apiKey = "1234"

    //Tests
    //This now implicitly tests the KVO implementation used under the covers. Unsure if we should make this more explicit or not in the future.
    guard let queryParams = MapzenSearch.sharedInstance.urlQueryItems else {
      XCTFail("urlQueryItems should be initialized by this point, but aren't")
      return
    }
    //There should only be one at this point
    XCTAssertTrue(queryParams[0].value == "1234")

    //Now test it gets removed
    MapzenManager.sharedManager.apiKey = nil
    guard let params = PeliasSearchManager.sharedInstance.urlQueryItems else {
      XCTFail("urlQueryItems should be initialized by this point, but aren't")
      return
    }
    XCTAssertTrue(params.count == 0)
  }

  func testHttpHeaders() {
    let headers = MapzenManager.sharedManager.httpHeaders()
    guard let userAgentString = headers["User-Agent"] else {
      XCTFail("User-Agent header is nil")
      return
    }
    XCTAssertTrue(userAgentString.contains("ios-sdk"))
  }
}
