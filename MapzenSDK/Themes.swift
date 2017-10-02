//
//  Themes.swift
//  ios-sdk
//
//  Created by Matt Smollinger on 9/28/17.
//  Copyright © 2017 Mapzen. All rights reserved.
//

import Foundation

public protocol StyleSheet : class {

  var fileLocation: URL? { get }
  static var stylesheetRoot: String { get }
  var appliedTheme: Theme { get }
  var houseStylesRoot: String { get }
  static var styleSheetFileName: String { get }
  var importString: String { get }
  var relativePath: String { get }
}

extension StyleSheet {
  public var fileLocation: URL? {
    get {
      return Bundle.houseStylesBundle()?.url(forResource: relativePath, withExtension: "yaml")
    }
  }

  public var houseStylesRoot: String {
    get {
      return "housestyles.bundle/"
    }
  }

  public var importString: String {
    get {
      return "{ import: [ \(relativePath).yaml, \(appliedTheme.yamlString) ] }"
    }
  }

  public var relativePath: String {
    get {
      return "\(Self.stylesheetRoot)\(Self.styleSheetFileName)"
    }
  }
}

public protocol Theme : class {

  var yamlString: String { get }
  var detailLevel: Int { get set }
  var labelLevel: Int { get set }
  var currentColor: String { get set }

  var availableColors: [ String ] { get }
  var availableDetailLevel: Int { get }
  var availableLabelLevels: Int { get }

}

//MARK:- Bubble Wrap
open class BubbleWrapStyle: NSObject, StyleSheet {
  open var appliedTheme: Theme = BubbleWrapTheme()
  open static let styleSheetFileName = "bubble-wrap-style"
  open static let stylesheetRoot = "bubble-wrap/"

}

open class BubbleWrapTheme: NSObject, Theme {
  open var availableLabelLevels: Int = 12

  open var availableDetailLevel: Int = 0 // Not used for Bubble Wrap

  open var availableColors: [String] = [] // Not used for Bubble Wrap

  open var currentColor: String = "" // Not used for Bubble Wrap

  open var labelLevel: Int = 5

  open var detailLevel: Int = 0 // Not used for Bubble Wrap

  open var yamlString: String {
    get {
      return "\(BubbleWrapStyle.stylesheetRoot)themes/label-\(labelLevel).yaml"
    }
  }
}

//MARK:- Cinnnabar
open class CinnabarStyle: NSObject, StyleSheet {
  open var appliedTheme: Theme = CinnabarTheme()
  open static let styleSheetFileName = "cinnabar-style"
  open static let stylesheetRoot = "cinnabar/"
}

open class CinnabarTheme: NSObject, Theme {
  open var availableLabelLevels: Int = 12

  open var availableDetailLevel: Int = 0 // Not used for Cinnabar

  open var availableColors: [String] = [] // Not used for Cinnabar

  open var currentColor: String = "" // Not used for Cinnabar

  open var labelLevel: Int = 5

  open var detailLevel: Int = 0 // Not used for Cinnabar

  open var yamlString: String {
    get {
      return "\(CinnabarStyle.stylesheetRoot)themes/label-\(labelLevel).yaml"
    }
  }
}

//MARK:- Refill
open class RefillStyle: NSObject, StyleSheet {
  open var appliedTheme: Theme = RefillTheme()
  open static let styleSheetFileName = "refill-style"
  open static let stylesheetRoot = "refill/"
}

open class RefillTheme: NSObject, Theme {
  open var availableLabelLevels: Int = 12

  open var availableDetailLevel: Int = 12

  open var availableColors: [String] = ["black", "blue-gray", "blue", "brown-orange", "gray-gold", "gray", "high-contrast", "inverted", "pink-yellow", "pink", "purple-green", "sepia", "zinc"]

  open var currentColor: String = "black"

  open var labelLevel: Int = 5

  open var detailLevel: Int = 5

  open var yamlString: String {
    get {
      return "\(RefillStyle.stylesheetRoot)themes/label-\(labelLevel).yaml, \(RefillStyle.stylesheetRoot)themes/detail-\(detailLevel).yaml, \(RefillStyle.stylesheetRoot)themes/color-\(currentColor).yaml"
    }
  }
}

//MARK:- Zinc
open class ZincStyle: RefillStyle {
  override init() {
    super.init()
    defer {
      self.appliedTheme.currentColor = "zinc"
    }
  }
}

//MARK:- Walkabout
open class WalkaboutStyle: NSObject, StyleSheet {
  open var appliedTheme: Theme = WalkaboutTheme()
  open static let styleSheetFileName = "walkabout-style"
  open static let stylesheetRoot = "walkabout/"
}

open class WalkaboutTheme: NSObject, Theme {
  open var availableLabelLevels: Int = 12

  open var availableDetailLevel: Int = 0 // Not used for Walkabout

  open var availableColors: [String] = [] // Not used for Walkabout

  open var currentColor: String = "" // Not used for Walkabout

  open var labelLevel: Int = 5

  open var detailLevel: Int = 0 // Not used for Walkabout

  open var yamlString: String {
    get {
      return "\(WalkaboutStyle.stylesheetRoot)themes/label-\(labelLevel).yaml"
    }
  }
}
