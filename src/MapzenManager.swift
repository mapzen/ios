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

open class MapzenManager: NSObject {
  open static let sharedManager = MapzenManager()

  open var apiKey: String? {
    didSet {
      guard let apiKey = apiKey else {
        if let queryItems = PeliasSearchManager.sharedInstance.urlQueryItems {
          for (index, queryItem) in queryItems.enumerated() {
            if queryItem.name == "api_key" {
              PeliasSearchManager.sharedInstance.urlQueryItems?.remove(at: index)
            } // if queryItem
          } // for (index, queryItem)
        } // if let queryItems
        return
      }

      PeliasSearchManager.sharedInstance.urlQueryItems = [URLQueryItem(name: "api_key", value: apiKey)]



    } // didSet
  } // apiKey

  fileprivate override init(){
    super.init()
  }
}
