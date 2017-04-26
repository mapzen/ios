//
//  DictionaryExtensionsTests.swift
//  ios-sdk
//
//  Created by Sarah Lensing on 2/27/17.
//  Copyright © 2017 Mapzen. All rights reserved.
//

import XCTest
@testable import MapzenSDK

class DictionaryExtensionsTests : XCTestCase {

  let numbers = [1: "1", 2: "2", 3: "3" ]
  let phones = ["sarah": "iphone", "matt": "iphone", "chuck": "pixel"]

  func testNumbersKeysForValue() {
    let keys = numbers.keysForValue(value: "2")
    XCTAssertEqual(keys.count, 1)
    XCTAssertEqual(keys.first, 2)
  }

  func testNumbersKeysForValueEmpty() {
    let keys = numbers.keysForValue(value: "4")
    XCTAssertTrue(keys.isEmpty)
  }

  func testNumbersKeyForValue() {
    let key = numbers.keyForValue(value: "1")
    XCTAssertEqual(key, 1)
  }

  func testNumbersKeyForValueNil() {
    let key = numbers.keyForValue(value: "4")
    XCTAssertNil(key)
  }

  func testPhonesKeysForValue() {
    let keys = phones.keysForValue(value: "iphone")
    XCTAssertEqual(keys.count, 2)
    XCTAssertTrue(keys.contains("sarah"))
    XCTAssertTrue(keys.contains("matt"))
  }

  func testPhonesKeysForValueEmpty() {
    let keys = phones.keysForValue(value: "razr")
    XCTAssertTrue(keys.isEmpty)
  }

  func testPhonesKeyForValue() {
    let key = phones.keyForValue(value: "pixel")
    XCTAssertEqual(key, "chuck")
  }

  func testPhonesKeyForValueNil() {
    let key = phones.keyForValue(value: "razr")
    XCTAssertNil(key)
  }
}
