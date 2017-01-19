//
//  MapzenRoutingController.swift
//  ios-sdk
//
//  Created by Matt Smollinger on 1/13/17.
//  Copyright © 2017 Mapzen. All rights reserved.
//

import UIKit
import OnTheRoad

public class MapzenRoutingController: OTRRoutingController {

  private override init() {
    super.init()
  }

  public static func controller() throws -> MapzenRoutingController {
    guard let apiKey = MapzenManager.sharedManager.apiKey else {
      throw NSError(domain: MapViewController.MapzenGeneralErrorDomain,
                    code: MZError.APIKeyNotSet.rawValue,
                    userInfo: nil)
    }
    let controller = MapzenRoutingController()
    controller.urlQueryComponents.addObject(NSURLQueryItem(name: "api_key", value: apiKey))
    return controller
  }
}
