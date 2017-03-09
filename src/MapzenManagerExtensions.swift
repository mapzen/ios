//
//  MapzenManagerExtensions.swift
//  ios-sdk
//
//  Created by Sarah Lensing on 3/9/17.
//  Copyright © 2017 Mapzen. All rights reserved.
//

import Foundation

protocol MapzenManagerProtocol {
  var apiKey: String? { set get }
}

extension MapzenManager: MapzenManagerProtocol {}
