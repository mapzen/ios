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

public class MapzenManager: NSObject {
  public static let sharedManager = MapzenManager()

  public var apiKey: String? {
    didSet {
      guard let apiKey = apiKey else {
        if let queryItems = PeliasSearchManager.sharedInstance.urlQueryItems {
          for (index, queryItem) in queryItems.enumerate() {
            if queryItem.name == "api_key" {
              PeliasSearchManager.sharedInstance.urlQueryItems?.removeAtIndex(index)
            } // if queryItem
          } // for (index, queryItem)
        } // if let queryItems
        return
      }

      PeliasSearchManager.sharedInstance.urlQueryItems = [NSURLQueryItem(name: "api_key", value: apiKey)]



    } // didSet
  } // apiKey

  private override init(){
    super.init()
  }
}
