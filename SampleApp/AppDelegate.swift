//
//  AppDelegate.swift
//  ios-sdk
//
//  Created by Matt Smollinger on 3/8/16.
//  Copyright © 2016 Mapzen. All rights reserved.
//

import UIKit
import HockeySDK
import MapzenSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?


  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    startCrashReporter()
    let apiKey = getEnvironmentVariable(key: "MAPZEN_API_KEY")
    assert(apiKey.contains("mapzen-"), "Set your Mapzen API key in the scheme by adding a MAPZEN_API_KEY environment variable.")
    MapzenManager.sharedManager.apiKey = apiKey
    return true
  }

  private func startCrashReporter() {
    let manager = BITHockeyManager.shared()
    manager.configure(withIdentifier: getEnvironmentVariable(key: "HOCKEY_APP_ID"))
    manager.crashManager.crashManagerStatus = .autoSend
    manager.start()
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
