//
//  MapzenManager.swift
//  ios-sdk
//
//  Created by Matt Smollinger on 1/12/17.
//  Copyright © 2017 Mapzen. All rights reserved.
//

import Foundation
import Pelias
import OnTheRoad

protocol MapzenManagerProtocol {
  var apiKey: String? { set get }
}

/**
 `MapzenManager` is a singleton object used for managing state between the various dependencies. Right now, it only manages the API key system.
 */
open class MapzenManager: NSObject, MapzenManagerProtocol {
  /// The single object to be used for all access
  open static let sharedManager = MapzenManager()
  static let SDK_VERSION_KEY = "sdk_version"

  /// The Mapzen API key. If this is not set, exceptions will get raised by the various objects in use.
  dynamic open var apiKey: String?

  fileprivate override init(){
    super.init()
  }

  //MARK: - Http Headers
  func httpHeaders() -> [String:String] {
    var headers = [String:String]()
    headers["User-Agent"] = buildUserAgent()
    return headers
  }

  fileprivate func buildUserAgent() -> String {
    let systemVersion = UIDevice.current.systemVersion
    var sdkVersion = "0"
    //Now for the fun - we grab the current bundle
    let bundle = Bundle(for: MapzenManager.self)
    // Assuming cocoapods did its thing and ran setup_version.swift, there will be a version.plist in our bundle
    if let pathForVersionPlist = bundle.path(forResource: "version", ofType: "plist") {
      if let versionDict = NSDictionary(contentsOfFile: pathForVersionPlist) {
        if let version = versionDict[MapzenManager.SDK_VERSION_KEY] {
          sdkVersion = version as! String
        }
      }
    }
    return "ios-sdk;\(sdkVersion),\(systemVersion)"
  }
}
