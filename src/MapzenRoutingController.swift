//
//  MapzenRoutingController.swift
//  ios-sdk
//
//  Created by Matt Smollinger on 1/13/17.
//  Copyright © 2017 Mapzen. All rights reserved.
//

import UIKit
import OnTheRoad

open class MapzenRoutingController: OTRRoutingController {

  fileprivate override init() {
    super.init()
  }

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
