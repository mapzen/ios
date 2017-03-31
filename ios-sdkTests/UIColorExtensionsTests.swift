//
//  UIColorExtensionsTests.swift
//  ios-sdk
//
//  Created by Sarah Lensing on 3/31/17.
//  Copyright © 2017 Mapzen. All rights reserved.
//

@testable import ios_sdk
import XCTest

class UIColorExtensionsTests : XCTestCase {

  func testHexNoAlpha() {
    let hex = UIColor.red.hexValue()
    XCTAssertEqual(hex, "#FFFF0000")
  }

  func testHexAlpha() {
    let hex = UIColor.blue.withAlphaComponent(0.5).hexValue()
    XCTAssertEqual(hex, "#800000FF")
  }
}
