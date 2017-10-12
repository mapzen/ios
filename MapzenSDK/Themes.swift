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


public protocol StyleSheet : class {

  var fileLocation: URL? { get }
  var remoteFileLocation: URL? { get }
  static var stylesheetRoot: String { get }
  var appliedTheme: Theme { get }
  var houseStylesRoot: String { get }
  static var styleSheetFileName: String { get }
  var importString: String { get }
  var relativePath: String { get }
  var mapStyle: MapStyle? { get set }
}

extension StyleSheet {
  public var fileLocation: URL? {
    get {
      return Bundle.houseStylesBundle()?.url(forResource: relativePath, withExtension: "yaml")
    }
  }

  public var remoteFileLocation: URL? {
    get {
      return nil
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
  open var mapStyle: MapStyle? = .bubbleWrap
  @objc open static let styleSheetFileName = "bubble-wrap-style"
  @objc open static let stylesheetRoot = "bubble-wrap/"

}

open class BubbleWrapTheme: NSObject, Theme {
  @objc open var availableLabelLevels: Int = 12

  @objc open var availableDetailLevel: Int = 0 // Not used for Bubble Wrap

  @objc open var availableColors: [String] = [] // Not used for Bubble Wrap

  @objc open var currentColor: String = "" // Not used for Bubble Wrap

  @objc open var labelLevel: Int = 5

  @objc open var detailLevel: Int = 0 // Not used for Bubble Wrap

  @objc open var yamlString: String {
    get {
      return "\(BubbleWrapStyle.stylesheetRoot)themes/label-\(labelLevel).yaml"
    }
  }
}

//MARK:- Cinnnabar
open class CinnabarStyle: NSObject, StyleSheet {
  open var appliedTheme: Theme = CinnabarTheme()
  open var mapStyle: MapStyle? = .cinnabar
  @objc open static let styleSheetFileName = "cinnabar-style"
  @objc open static let stylesheetRoot = "cinnabar/"
}

open class CinnabarTheme: NSObject, Theme {
  @objc open var availableLabelLevels: Int = 12

  @objc open var availableDetailLevel: Int = 0 // Not used for Cinnabar

  @objc open var availableColors: [String] = [] // Not used for Cinnabar

  @objc open var currentColor: String = "" // Not used for Cinnabar

  @objc open var labelLevel: Int = 5

  @objc open var detailLevel: Int = 0 // Not used for Cinnabar

  @objc open var yamlString: String {
    get {
      return "\(CinnabarStyle.stylesheetRoot)themes/label-\(labelLevel).yaml"
    }
  }
}

//MARK:- Refill
open class RefillStyle: NSObject, StyleSheet {
  open var appliedTheme: Theme = RefillTheme()
  open var mapStyle: MapStyle? = .refill
  @objc open static let styleSheetFileName = "refill-style"
  @objc open static let stylesheetRoot = "refill/"
}

open class RefillTheme: NSObject, Theme {
  @objc open var availableLabelLevels: Int = 12

  @objc open var availableDetailLevel: Int = 12

  @objc open var availableColors: [String] = ["black", "blue-gray", "blue", "brown-orange", "gray-gold", "gray", "high-contrast", "inverted", "pink-yellow", "pink", "purple-green", "sepia", "zinc"]

  @objc open var currentColor: String = "black"

  @objc open var labelLevel: Int = 5

  @objc open var detailLevel: Int = 10

  @objc open var yamlString: String {
    get {
      return "\(RefillStyle.stylesheetRoot)themes/label-\(labelLevel).yaml, \(RefillStyle.stylesheetRoot)themes/detail-\(detailLevel).yaml, \(RefillStyle.stylesheetRoot)themes/color-\(currentColor).yaml"
    }
  }
}

//MARK:- Zinc
open class ZincStyle: RefillStyle {
  public override init() {
    super.init()
    defer {
      mapStyle = .zinc
      self.appliedTheme.currentColor = "zinc"
    }
  }
}

//MARK:- Walkabout
open class WalkaboutStyle: NSObject, StyleSheet {
  open var appliedTheme: Theme = WalkaboutTheme()
  open var mapStyle: MapStyle? = .walkabout
  @objc open static let styleSheetFileName = "walkabout-style"
  @objc open static let stylesheetRoot = "walkabout/"
}

open class WalkaboutTheme: NSObject, Theme {
  @objc open var availableLabelLevels: Int = 12

  @objc open var availableDetailLevel: Int = 0 // Not used for Walkabout

  @objc open var availableColors: [String] = [] // Not used for Walkabout

  @objc open var currentColor: String = "" // Not used for Walkabout

  @objc open var labelLevel: Int = 5

  @objc open var detailLevel: Int = 0 // Not used for Walkabout

  @objc open var yamlString: String {
    get {
      return "\(WalkaboutStyle.stylesheetRoot)themes/label-\(labelLevel).yaml"
    }
  }
}
