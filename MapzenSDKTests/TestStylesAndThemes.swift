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

  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }

  func testBubbleWrapStyleDefaults() {
    let style = BubbleWrapStyle()
    XCTAssertTrue(style.appliedTheme is BubbleWrapTheme)
    XCTAssertTrue(style.mapStyle == .bubbleWrap)
    XCTAssertTrue(BubbleWrapStyle.stylesheetRoot == "bubble-wrap/")
    XCTAssertTrue(BubbleWrapStyle.styleSheetFileName == "bubble-wrap-style")
  }

  func testBubbleWrapImportString() {
    let style = BubbleWrapStyle()
    XCTAssertTrue(style.importString == "{ import: [ bubble-wrap/bubble-wrap-style.yaml, bubble-wrap/themes/label-5.yaml ] }")
  }

  func testBubbleWrapThemeDefaults() {
    let theme = BubbleWrapTheme()
    XCTAssertTrue(theme.availableLabelLevels == 12)
    XCTAssertTrue(theme.availableDetailLevel == 0)
    XCTAssertTrue(theme.availableColors == [])
    XCTAssertTrue(theme.currentColor == "")
    XCTAssertTrue(theme.labelLevel == 5)
    XCTAssertTrue(theme.detailLevel == 0)
    XCTAssertTrue(theme.yamlString == "bubble-wrap/themes/label-5.yaml")
  }

  func testCinnabarStyleDefaults() {
    let style = CinnabarStyle()
    XCTAssertTrue(style.appliedTheme is CinnabarTheme)
    XCTAssertTrue(style.mapStyle == .cinnabar)
    XCTAssertTrue(CinnabarStyle.stylesheetRoot == "cinnabar/")
    XCTAssertTrue(CinnabarStyle.styleSheetFileName == "cinnabar-style")
  }

  func testCinnabarImportString() {
    let style = CinnabarStyle()
    XCTAssertTrue(style.importString == "{ import: [ cinnabar/cinnabar-style.yaml, cinnabar/themes/label-5.yaml ] }")
  }

  func testCinnabarThemeDefaults() {
    let theme = CinnabarTheme()
    XCTAssertTrue(theme.availableLabelLevels == 12)
    XCTAssertTrue(theme.availableDetailLevel == 0)
    XCTAssertTrue(theme.availableColors == [])
    XCTAssertTrue(theme.currentColor == "")
    XCTAssertTrue(theme.labelLevel == 5)
    XCTAssertTrue(theme.detailLevel == 0)
    XCTAssertTrue(theme.yamlString == "cinnabar/themes/label-5.yaml")
  }

  func testRefillStyleDefaults() {
    let style = RefillStyle()
    XCTAssertTrue(style.appliedTheme is RefillTheme)
    XCTAssertTrue(style.mapStyle == .refill)
    XCTAssertTrue(RefillStyle.stylesheetRoot == "refill/")
    XCTAssertTrue(RefillStyle.styleSheetFileName == "refill-style")
  }

  func testRefillImportString() {
    let style = RefillStyle()
    XCTAssertTrue(style.importString == "{ import: [ refill/refill-style.yaml, refill/themes/label-5.yaml, refill/themes/detail-10.yaml, refill/themes/color-black.yaml ] }")
  }

  func testRefillThemeDefaults() {
    let theme = RefillTheme()
    XCTAssertTrue(theme.availableLabelLevels == 12)
    XCTAssertTrue(theme.availableDetailLevel == 12)
    XCTAssertTrue(theme.availableColors == ["black", "blue-gray", "blue", "brown-orange", "gray-gold", "gray", "high-contrast", "inverted", "pink-yellow", "pink", "purple-green", "sepia", "zinc"])
    XCTAssertTrue(theme.currentColor == "black")
    XCTAssertTrue(theme.labelLevel == 5)
    XCTAssertTrue(theme.detailLevel == 10)
    XCTAssertTrue(theme.yamlString == "refill/themes/label-5.yaml, refill/themes/detail-10.yaml, refill/themes/color-black.yaml")
  }

  func testZincDefaults() {
    let style = ZincStyle()
    XCTAssertTrue(style.mapStyle == .zinc)
    XCTAssertTrue(style.appliedTheme.currentColor == "zinc")
  }

  func testWalkaboutStyleDefaults() {
    let style = WalkaboutStyle()
    XCTAssertTrue(style.appliedTheme is WalkaboutTheme)
    XCTAssertTrue(style.mapStyle == .walkabout)
    XCTAssertTrue(WalkaboutStyle.stylesheetRoot == "walkabout/")
    XCTAssertTrue(WalkaboutStyle.styleSheetFileName == "walkabout-style")
  }

  func testWalkaboutImportString() {
    let style = WalkaboutStyle()
    XCTAssertTrue(style.importString == "{ import: [ walkabout/walkabout-style.yaml, walkabout/themes/label-5.yaml ] }")
  }

  func testWalkaboutThemeDefaults() {
    let theme = WalkaboutTheme()
    XCTAssertTrue(theme.availableLabelLevels == 12)
    XCTAssertTrue(theme.availableDetailLevel == 0)
    XCTAssertTrue(theme.availableColors == [])
    XCTAssertTrue(theme.currentColor == "")
    XCTAssertTrue(theme.labelLevel == 5)
    XCTAssertTrue(theme.detailLevel == 0)
    XCTAssertTrue(theme.yamlString == "walkabout/themes/label-5.yaml")
  }
}
