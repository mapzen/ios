//
//  TestStylesAndThemes.swift
//  ios-sdk
//
//  Created by Matt Smollinger on 10/3/17.
//  Copyright © 2017 Mapzen. All rights reserved.
//

import XCTest
@testable import MapzenSDK

class TestStylesAndThemes: XCTestCase {

  func testBubbleWrapStyleDefaults() {
    let style = BubbleWrapStyle()
    XCTAssertTrue(style.mapStyle == .bubbleWrap)
    XCTAssertTrue(style.styleSheetRoot == "bubble-wrap/")
    XCTAssertTrue(style.styleSheetFileName == "bubble-wrap-style")
  }

  func testBubbleWrapImportString() {
    let style = BubbleWrapStyle()
    XCTAssertTrue(style.importString == "{ import: [ bubble-wrap/bubble-wrap-style.yaml, bubble-wrap/themes/label-5.yaml ] }")
  }

  func testBubbleWrapThemeDefaults() {
    let style = BubbleWrapStyle()
    XCTAssertTrue(style.availableLabelLevels == 12)
    XCTAssertTrue(style.availableDetailLevels == 0)
    XCTAssertTrue(style.availableColors == [])
    XCTAssertTrue(style.currentColor == "")
    XCTAssertTrue(style.labelLevel == 5)
    XCTAssertTrue(style.detailLevel == 0)
    XCTAssertTrue(style.yamlString == "bubble-wrap/themes/label-5.yaml")
  }

  func testCinnabarStyleDefaults() {
    let style = CinnabarStyle()
    XCTAssertTrue(style.mapStyle == .cinnabar)
    XCTAssertTrue(style.styleSheetRoot == "cinnabar/")
    XCTAssertTrue(style.styleSheetFileName == "cinnabar-style")
  }

  func testCinnabarImportString() {
    let style = CinnabarStyle()
    XCTAssertTrue(style.importString == "{ import: [ cinnabar/cinnabar-style.yaml, cinnabar/themes/label-5.yaml ] }")
  }

  func testCinnabarThemeDefaults() {
    let style = CinnabarStyle()
    XCTAssertTrue(style.availableLabelLevels == 12)
    XCTAssertTrue(style.availableDetailLevels == 0)
    XCTAssertTrue(style.availableColors == [])
    XCTAssertTrue(style.currentColor == "")
    XCTAssertTrue(style.labelLevel == 5)
    XCTAssertTrue(style.detailLevel == 0)
    XCTAssertTrue(style.yamlString == "cinnabar/themes/label-5.yaml")
  }

  func testRefillStyleDefaults() {
    let style = RefillStyle()
    XCTAssertTrue(style.mapStyle == .refill)
    XCTAssertTrue(style.styleSheetRoot == "refill/")
    XCTAssertTrue(style.styleSheetFileName == "refill-style")
  }

  func testRefillImportString() {
    let style = RefillStyle()
    XCTAssertTrue(style.importString == "{ import: [ refill/refill-style.yaml, refill/themes/label-5.yaml, refill/themes/detail-10.yaml, refill/themes/color-black.yaml ] }")
  }

  func testRefillThemeDefaults() {
    let style = RefillStyle()
    XCTAssertTrue(style.availableLabelLevels == 12)
    XCTAssertTrue(style.availableDetailLevels == 12)
    XCTAssertTrue(style.availableColors == ["black", "blue-gray", "blue", "brown-orange", "gray-gold", "gray", "high-contrast", "inverted", "pink-yellow", "pink", "purple-green", "sepia", "zinc"])
    XCTAssertTrue(style.currentColor == "black")
    XCTAssertTrue(style.labelLevel == 5)
    XCTAssertTrue(style.detailLevel == 10)
    XCTAssertTrue(style.yamlString == "refill/themes/label-5.yaml, refill/themes/detail-10.yaml, refill/themes/color-black.yaml")
  }

  func testZincDefaults() {
    let style = ZincStyle()
    XCTAssertTrue(style.mapStyle == .zinc)
    XCTAssertTrue(style.currentColor == "zinc")
    XCTAssertTrue(style.yamlString == "refill/themes/label-5.yaml, refill/themes/detail-10.yaml, refill/themes/color-zinc.yaml")
  }

  func testWalkaboutStyleDefaults() {
    let style = WalkaboutStyle()
    XCTAssertTrue(style.mapStyle == .walkabout)
    XCTAssertTrue(style.styleSheetRoot == "walkabout/")
    XCTAssertTrue(style.styleSheetFileName == "walkabout-style")
  }

  func testWalkaboutImportString() {
    let style = WalkaboutStyle()
    XCTAssertTrue(style.importString == "{ import: [ walkabout/walkabout-style.yaml, walkabout/themes/label-5.yaml ] }")
  }

  func testWalkaboutThemeDefaults() {
    let style = WalkaboutStyle()
    XCTAssertTrue(style.availableLabelLevels == 12)
    XCTAssertTrue(style.availableDetailLevels == 0)
    XCTAssertTrue(style.availableColors == [])
    XCTAssertTrue(style.currentColor == "")
    XCTAssertTrue(style.labelLevel == 5)
    XCTAssertTrue(style.detailLevel == 0)
    XCTAssertTrue(style.yamlString == "walkabout/themes/label-5.yaml")
  }
}
