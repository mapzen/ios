//
//  TestLocationManager.swift
//  ios-sdk
//
//  Created by Sarah Lensing on 3/8/17.
//  Copyright © 2017 Mapzen. All rights reserved.
//

import CoreLocation
@testable import MapzenSDK

class TestLocationManager : LocationManagerProtocol {

  open weak var delegate: LocationManagerDelegate?

  var currentLocation: CLLocation?

  var requestedInUse = false

  func requestAlwaysAuthorization() {

  }

  func requestWhenInUseAuthorization() {
    requestedInUse = true
  }

  func isInUseAuthorized() -> Bool {
    return true
  }

  func isAlwaysAuthorized() -> Bool {
    return true
  }

  func refreshCurrentLocation() -> CLLocation? {
    return nil
  }

  func requestLocation() {

  }

  func startUpdatingLocation() {

  }

  func stopUpdatingLocation() {

  }

}
