//
//  AppDelegate.swift
//  ios-sdk
//
//  Created by Matt Smollinger on 3/8/16.
//  Copyright © 2016 Mapzen. All rights reserved.
//

import UIKit
import Mapzen_ios_sdk

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  static let MapUpdateNotification = NSNotification.Name(rawValue: "MapUpdateNotification")

  var selectedMapStyle: StyleSheet = BubbleWrapStyle() {
    didSet {
      NotificationCenter.default.post(name: AppDelegate.MapUpdateNotification, object: nil)
    }
  }


  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    let apiKey = getEnvironmentVariable(key: "MAPZEN_API_KEY")
    assert(apiKey.contains("mapzen-"), "Set your Mapzen API key in the scheme by adding a MAPZEN_API_KEY environment variable.")
    MapzenManager.sharedManager.apiKey = apiKey
    return true
  }

  private func getEnvironmentVariable(key: String) -> String {
    var envVar = ""
    // xcodebuild arg
    if let bundleVar = Bundle.main.infoDictionary?[key] as? String {
      if !bundleVar.isEmpty {
        envVar = bundleVar
      }
    }
    // scheme environment variables
    if envVar.isEmpty, let processVar = ProcessInfo.processInfo.environment[key] {
      envVar = processVar
    }
    return envVar
  }
}
