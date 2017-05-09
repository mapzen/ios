//
//  SearchResponseTests.swift
//  ios-sdk
//
//  Created by Sarah Lensing on 3/21/17.
//  Copyright © 2017 Mapzen. All rights reserved.
//

import XCTest
@testable import MapzenSDK
import Pelias

class SearchResponseTests: XCTestCase {
  var data = Data()
  let urlResponse = URLResponse()
  let error = NSError(domain:"Test", code: 1, userInfo: nil)
  var response: SearchResponse?
  var peliasResponse:PeliasResponse?

  override func setUp() {
    peliasResponse = PeliasResponse(data: data, response: urlResponse, error: error)
    response = SearchResponse(peliasResponse!)
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

  func testParsedResponse() {
    let dict = ["type":"FeatureCollection"]
    try? data = JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
    let pr = PeliasResponse(data: data, response: urlResponse, error: error)
    let r = SearchResponse(pr)
    XCTAssertEqual(r.parsedResponse?.parsedResponse.keys.count, 1)
    XCTAssertEqual(r.parsedResponse?.parsedResponse["type"] as! String, "FeatureCollection")
  }

  func testEquals() {
    let otherResponse = SearchResponse(PeliasResponse(data: Data(), response: urlResponse, error: NSError(domain:"Test", code: 1, userInfo: nil)))
    XCTAssertEqual(response, otherResponse)
  }
}

class ParsedSearchResponseTests: XCTestCase {

  func testEncodeDecode() {
    let dict = ["test":"result"]
    let pr = PeliasSearchResponse(parsedResponse: dict)
    let parsedResponse = ParsedSearchResponse.init(pr)
    ParsedSearchResponse.encode(parsedResponse)
    let decoded = parsedResponse.decode()
    XCTAssertEqual(decoded?.peliasResponse.parsedResponse.keys.count, 1)
    XCTAssertEqual(decoded?.peliasResponse.parsedResponse["test"] as! String, "result")
  }
}
