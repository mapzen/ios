//
//  Themes.swift
//  ios-sdk
//
//  Created by Matt Smollinger on 9/28/17.
//  Copyright © 2017 Mapzen. All rights reserved.
//

import Foundation

protocol StyleSheet {

  var fileLocation: URL? { get }
  var stylesheetRoot: String { get }
  var appliedTheme: Theme { get }
  var houseStylesRoot: String { get }
  var styleSheetFileName: String { get }
  var importString: String { get }
}

extension StyleSheet {
  var fileLocation: URL? {
    get {
      return Bundle.houseStylesBundle()?.url(forResource: styleSheetFileName, withExtension: "yaml")
    }
  }

  var houseStylesRoot: String {
    get {
      return "housestyles.bundle/"
    }
  }

  var importString: String {
    get {
      return "{ import: [ \(styleSheetFileName).yaml, \(appliedTheme.yamlString) ] }"
    }
  }
}

protocol Theme {

  var yamlString: String { get }
  var detailLevel: Int { get set }
  var labelLevel: Int { get set }
  var currentColor: String { get set }

  var availableColors: [ String ] { get }
  var availableDetailLevel: Int { get }
  var availableLabelLevels: Int { get }

}



//class CinnabarStyle: NSObject, StyleSheet {
//  var appliedTheme: Theme?
//  let fileLocation = URL(fileURLWithPath: "/test")
//  let stylesheetRoot = "cinnabar/"
//}
//
//class RefillStyle: NSObject, StyleSheet {
//  var appliedTheme: Theme?
//  let fileLocation = URL(fileURLWithPath: "/test")
//  let stylesheetRoot = "refill/"
//}
//
//class WalkaboutStyle: NSObject, StyleSheet {
//  var appliedTheme: Theme?
//  let fileLocation = URL(fileURLWithPath: "/test")
//  let stylesheetRoot = "walkabout/"
//}

//MARK:- Bubble Wrap
class BubbleWrapStyle: NSObject, StyleSheet {
  var appliedTheme: Theme = BubbleWrapTheme()
  var styleSheetFileName = "bubble-wrap-style"
  let fileLocation = URL(fileURLWithPath: "/test")
  let stylesheetRoot = "bubble-wrap/"

}

class BubbleWrapTheme: NSObject, Theme {
  var availableLabelLevels: Int = 12

  var availableDetailLevel: Int = 0 // Not used for Bubble Wrap

  var availableColors: [String] = [] // Not used for Bubble Wrap

  var currentColor: String = "" // Not used for Bubble Wrap

  var labelLevel: Int = 5

  var detailLevel: Int = 0 // Not used for Bubble Wrap

  var yamlString: String {
    get {
      return "themes/label-\(labelLevel).yaml"
    }
  }
}
