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

  private static let kApiKey = "api_key"
  private static let kLanguageKey = "language"

  private var locale = Locale.current

  fileprivate override init() {
    super.init()
  }

  fileprivate override init(sessionManager : URLSession) {
    super.init(sessionManager: sessionManager)
  }

  /// Static function that vends a properly configured routing controller.
  open static func controller() throws -> MapzenRoutingController {
    let session = URLSession.init(configuration: URLSessionConfiguration.default)
    return try MapzenRoutingController.controller(sessionManager: session)
  }

  /** Static function that vends a properly configured routing controller given a session manager. Useful for testing
   - parameter sessionManager : URLSession object to use for requests
  */
  open static func controller(sessionManager : URLSession) throws -> MapzenRoutingController {
    guard let apiKey = MapzenManager.sharedManager.apiKey else {
      throw NSError(domain: MapViewController.MapzenGeneralErrorDomain,
                    code: MZError.apiKeyNotSet.rawValue,
                    userInfo: nil)
    }
    let controller = MapzenRoutingController.init(sessionManager: sessionManager)
    controller.urlQueryComponents.add(URLQueryItem(name: kApiKey, value: apiKey))
    return controller
  }

  /** 
   Set the locale to determine the language the route's directions are in. The default value is Locale.current
   
   To see a list of supported languages, check the documentation: https://mapzen.com/documentation/mobility/turn-by-turn/api-reference/#directions-options
   */
  open func updateLocale(_ l: Locale) {
    locale = l
  }

  override open func requestRoute(withLocations locations: [OTRRoutingPoint], costingModel costing: OTRRoutingCostingModel, costingOption costingOptions: [String : NSObject]?, directionsOptions: [String : NSObject]? = nil, callback: @escaping (OTRRoutingResult?, Any?, Error?) -> Swift.Void) -> URLSessionDataTask? {
    guard let localeLanguage = locale.languageCode else {
      return super.requestRoute(withLocations: locations, costingModel: costing, costingOption: costingOptions, directionsOptions: directionsOptions, callback: callback)
    }
    guard var allDirectionsOptions = directionsOptions else {
      let defaultDirectionsOptions = [MapzenRoutingController.kLanguageKey : localeLanguage as NSObject]
      return super.requestRoute(withLocations: locations, costingModel: costing, costingOption: costingOptions, directionsOptions: defaultDirectionsOptions, callback: callback)
    }

    if !allDirectionsOptions.keys.contains(MapzenRoutingController.kLanguageKey) {
      allDirectionsOptions[MapzenRoutingController.kLanguageKey] = localeLanguage as NSObject
    }

    return super.requestRoute(withLocations: locations, costingModel: costing, costingOption: costingOptions, directionsOptions: allDirectionsOptions, callback: callback)
  }
}
