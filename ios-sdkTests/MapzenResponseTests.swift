//
//  MapzenResponseTests.swift
//  ios-sdk
//
//  Created by Sarah Lensing on 3/21/17.
//  Copyright © 2017 Mapzen. All rights reserved.
//

import XCTest
@testable import ios_sdk
import Pelias

class MapzenResponseTests: XCTestCase {
  let data = Data()
  let urlResponse = URLResponse()
  let error = NSError(domain:"Test", code: 1, userInfo: nil)
  var response: MapzenResponse?

  override func setUp() {
     response = MapzenResponse(PeliasResponse(data: data, response: urlResponse, error: error))
  }

  func testData() {
    XCTAssertEqual(response?.peliasResponse.data, data)
    XCTAssertEqual(response?.data, data)
  }

  func testResponse() {
    XCTAssertEqual(response?.peliasResponse.response, urlResponse)
    XCTAssertEqual(response?.response, urlResponse)
  }

  func testError() {
    let error = NSError(domain:"Test", code: 1, userInfo: nil)
    XCTAssertEqual(response?.peliasResponse.error, error)
    XCTAssertEqual(response?.error, error)
  }

  func testEquals() {
    let otherResponse = MapzenResponse(PeliasResponse(data: Data(), response: urlResponse, error: NSError(domain:"Test", code: 1, userInfo: nil)))
    XCTAssertEqual(response, otherResponse)
  }
}
