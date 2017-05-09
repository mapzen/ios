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
import OnTheRoad

/// Convenience extension to convert between the different coordinate systems in use
public extension TGGeoPoint {
  /** 
   Creates a TGGeoPoint from a CoreLocation coordinate struct.

   - parameter coordinate: The CLLocationCoordinate2D struct to use.
   - returns: A TGGeoPoint structure.
   */
  public init(coordinate: CLLocationCoordinate2D) {
    self.init(longitude: coordinate.longitude, latitude: coordinate.latitude)
  }

  /** 
    Creates a TGGeoPoint from a On The Road Geopoint
   
    - parameter coordinate: The OTRGeoPoint to use.
    - returns: A TGGeoPoint structure.
   */
  public init(coordinate: OTRGeoPoint) {
    self.init(longitude: coordinate.longitude, latitude: coordinate.latitude)
  }

  /** 
    Create a TGGeoPoint from a CoreLocation location object
    
    - parameter location: The location object to use
    - returns: A TGGeoPoint structure.
    */
  public init(location: CLLocation) {
    self.init(coordinate: location.coordinate)
  }
}

public extension OTRGeoPoint {
  /**
   Creates a OTRGeoPoint from a TGGeoPoint

   - parameter coordinate: The OTRGeoPoint to use.
   - returns: A TGGeoPoint structure.
   */
  public init(coordinate: TGGeoPoint) {
    self.init(latitude: coordinate.latitude, longitude: coordinate.longitude)
  }
}
