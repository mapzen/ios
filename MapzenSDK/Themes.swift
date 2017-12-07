//
//  Themes.swift
//  ios-sdk
//
//  Created by Matt Smollinger on 9/28/17.
//  Copyright © 2017 Mapzen. All rights reserved.
//

import Foundation

/**
 This is the foundational code for custom stylesheet and theme support. This area will likely be the focus of updates & changes over the next several releases, so we would recommend avoiding implementing your own custom stylesheet classes until we have further vetted this implementation. Documentation will be written once we've solidified on the protocol requirements and implementation details.

 We do however welcome suggestions / improvements to this API on our github at https://github.com/mapzen/ios
 */

@objc(MZStyleSheet)
public protocol StyleSheet : class {

  @objc var fileLocation: URL? { get }
  @objc var remoteFileLocation: URL? { get }
  @objc var styleSheetRoot: String { get }
  @objc var houseStylesRoot: String { get }
  @objc var styleSheetFileName: String { get }
  @objc var importString: String { get }
  @objc var relativePath: String { get }
  @objc var mapStyle: MapStyle { get }
  @objc var yamlString: String { get }
  @objc var detailLevel: Int { get set }
  @objc var labelLevel: Int { get set }
  @objc var currentColor: String { get set }

  @objc var availableColors: [ String ] { get }
  @objc var availableDetailLevels: Int { get }
  @objc var availableLabelLevels: Int { get }
}

@objc(MZBaseStyle)
open class BaseStyle: NSObject, StyleSheet {

  @objc open var detailLevel: Int = 0
  @objc open var labelLevel: Int = 0
  @objc open var currentColor: String = ""

  @objc open var mapStyle: MapStyle {
    get {
      return .none
    }
  }

  @objc open var styleSheetFileName: String {
    get {
      return ""
    }
  }

  @objc open var styleSheetRoot: String {
    get {
      return ""
    }
  }

  @objc open var fileLocation: URL? {
    get {
      return Bundle.houseStylesBundle()?.url(forResource: relativePath, withExtension: "yaml")
    }
  }

  @objc open var remoteFileLocation: URL? {
    get {
      return nil
    }
  }

  @objc open var houseStylesRoot: String {
    get {
      return "housestyles.bundle/"
    }
  }

  @objc open var importString: String {
    get {
      return "{ import: [ \(relativePath).yaml, \(yamlString) ] }"
    }
  }

  @objc open var relativePath: String {
    get {
      return "\(styleSheetRoot)\(styleSheetFileName)"
    }
  }

  @objc open var yamlString: String {
    get {
      return ""
    }
  }

  @objc open var availableColors: [String] {
    get {
      return []
    }
  }

  @objc open var availableDetailLevels: Int {
    get {
      return 0
    }
  }

  @objc open var availableLabelLevels: Int {
    get {
      return 0
    }
  }
}

//MARK:- Bubble Wrap
@objc(MZBubbleWrapStyle)
open class BubbleWrapStyle: BaseStyle {
  public override init() {
    super.init()
    defer {
      currentColor = "" // Not used for Bubble Wrap
      labelLevel = 5
      detailLevel = 0 // Not used for Bubble Wrap
    }
  }

  @objc open override var mapStyle: MapStyle {
    get {
      return .bubbleWrap
    }
  }

  @objc open override var styleSheetFileName: String {
    get {
      return "bubble-wrap-style"
    }
  }

  @objc open override var styleSheetRoot: String {
    get {
      return "bubble-wrap/"
    }
  }

  @objc override open var availableLabelLevels: Int {
    get {
      return 12
    }
  }

  @objc override open var yamlString: String {
    get {
      return "\(styleSheetRoot)themes/label-\(labelLevel).yaml"
    }
  }
}

//MARK:- Cinnnabar
@objc(MZCinnabarStyle)
open class CinnabarStyle: BaseStyle {
  public override init() {
    super.init()
    defer {
      currentColor = "" // Not used for Cinnabar
      labelLevel = 5
      detailLevel = 0 // Not used for Cinnabar
    }
  }

  @objc open override var mapStyle: MapStyle {
    get {
      return .cinnabar
    }
  }

  @objc override open var styleSheetFileName: String {
    get {
      return "cinnabar-style"
    }
  }

  @objc override open var styleSheetRoot: String {
    get {
      return "cinnabar/"
    }
  }

  @objc override open var availableLabelLevels: Int {
    get {
      return 12
    }
  }

  @objc override open var yamlString: String {
    get {
      return "\(styleSheetRoot)themes/label-\(labelLevel).yaml"
    }
  }
}

//MARK:- Refill
@objc(MZRefillStyle)
open class RefillStyle: BaseStyle {
  public override init() {
    super.init()
    defer {
      currentColor = "black"
      labelLevel = 5
      detailLevel = 10
    }
  }

  @objc open override var mapStyle: MapStyle {
    get {
      return .refill
    }
  }

  @objc override open var styleSheetFileName: String {
    get {
      return "refill-style"
    }
  }

  @objc override open var styleSheetRoot: String {
    get {
      return "refill/"
    }
  }

  @objc override open var availableLabelLevels: Int {
    get {
      return 12
    }
  }

  @objc override open var availableDetailLevels: Int {
    get {
      return 12
    }
  }

  @objc override open var availableColors: [String] {
    get {
      return ["black", "blue-gray", "blue", "brown-orange", "gray-gold", "gray", "high-contrast", "inverted", "pink-yellow", "pink", "purple-green", "sepia", "zinc"]
    }
  }

  @objc override open var yamlString: String {
    get {
      return "\(styleSheetRoot)themes/label-\(labelLevel).yaml, \(styleSheetRoot)themes/detail-\(detailLevel).yaml, \(styleSheetRoot)themes/color-\(currentColor).yaml"
    }
  }
}

//MARK:- Zinc
@objc(MZZincStyle)
open class ZincStyle: RefillStyle {
  public override init() {
    super.init()
    defer {
      currentColor = "zinc"
    }
  }

  @objc open override var mapStyle: MapStyle {
    get {
      return .zinc
    }
  }
}

//MARK:- Walkabout
@objc(MZWalkaboutStyle)
open class WalkaboutStyle: BaseStyle {
  public override init() {
    super.init()
    defer {
      currentColor = "" // Not used for Walkabout
      labelLevel = 5
      detailLevel = 0 // Not used for Walkabout
    }
  }

  @objc open override var mapStyle: MapStyle {
    get {
      return .walkabout
    }
  }

  @objc override open var styleSheetFileName: String{
    get {
      return "walkabout-style"
    }
  }

  @objc override open var styleSheetRoot: String {
    get {
      return "walkabout/"
    }
  }

  @objc override open var availableLabelLevels: Int {
    get {
      return 12
    }
  }

  @objc override open var yamlString: String {
    get {
      return "\(styleSheetRoot)themes/label-\(labelLevel).yaml"
    }
  }
}
