//
//  TangramExtensions.swift
//  ios-sdk
//
//  Created by Matt Smollinger on 1/6/17.
//  Copyright © 2017 Mapzen. All rights reserved.
//

import Foundation
import TangramMap
import CoreLocation

public extension TGGeoPoint {
  public init(coordinate: CLLocationCoordinate2D) {
    self.init(longitude: coordinate.longitude, latitude: coordinate.latitude)
  }

  public init(location: CLLocation) {
    self.init(coordinate: location.coordinate)
  }
}
