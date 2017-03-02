//
//  MapzenRoutingController.swift
//  ios-sdk
//
//  Created by Matt Smollinger on 1/13/17.
//  Copyright © 2017 Mapzen. All rights reserved.
//

import UIKit
import OnTheRoad

/**
 `MapzenRoutingController` is a subclass of On The Road's routing controller and is the main access point in the SDK for querying for routes.
 - Note: The routing controller provides API key management and as such is expected to be retrieved via the `controller()` function so everything gets setup correctly.
 */
open class MapzenRoutingController: OTRRoutingController {

  fileprivate override init() {
    super.init()
  }

  /// Static function that vends a properly configured routing controller.
  open static func controller() throws -> MapzenRoutingController {
    guard let apiKey = MapzenManager.sharedManager.apiKey else {
      throw NSError(domain: MapViewController.MapzenGeneralErrorDomain,
                    code: MZError.apiKeyNotSet.rawValue,
                    userInfo: nil)
    }
    let controller = MapzenRoutingController()
    controller.urlQueryComponents.add(URLQueryItem(name: "api_key", value: apiKey))
    return controller
  }
}
