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

/**
 `MapzenManager` is a singleton object used for managing state between the various dependencies. Right now, it only manages the API key system.
 */
open class MapzenManager: NSObject {
  /// The single object to be used for all access
  open static let sharedManager = MapzenManager()

  /// The Mapzen API key. If this is not set, exceptions will get raised by the various objects in use.
  dynamic open var apiKey: String?

  fileprivate override init(){
    super.init()
  }
}
