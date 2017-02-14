//
//  LocationManager.swift
//  ios-sdk
//
//  Created by Matt Smollinger on 11/22/16.
//  Copyright © 2016 Mapzen. All rights reserved.
//

import UIKit
import CoreLocation
import OnTheRoad

extension OTRGeoPoint {
  
}

@objc public protocol LocationManagerDelegate {
  @objc optional func authorizationDidSucceed()
  @objc optional func authorizationDenied()
  @objc optional func authorizationRestricted()
  @objc optional func locationDidUpdate(_ location: CLLocation)
}


open class LocationManager: NSObject, CLLocationManagerDelegate {

  open static let sharedManager = LocationManager()
  open var currentLocation: CLLocation?
  open weak var delegate: LocationManagerDelegate?

  fileprivate let coreLocationManager = CLLocationManager()
  fileprivate override init(){
    super.init()
    coreLocationManager.delegate = self
  }

  open func requestAlwaysAuthorization() {
    coreLocationManager.requestAlwaysAuthorization()

  }

  open func requestWhenInUseAuthorization() {
    coreLocationManager.requestWhenInUseAuthorization()
  }

  open func isInUseAuthorized() -> Bool {
    return CLLocationManager.authorizationStatus() == .authorizedWhenInUse ? true :  false
  }

  open func isAlwaysAuthorized() -> Bool {
        return CLLocationManager.authorizationStatus() == .authorizedAlways ? true :  false
  }

  open func refreshCurrentLocation() -> CLLocation? {
    if CLLocationManager.locationServicesEnabled() &&
      (CLLocationManager.authorizationStatus() == .authorizedAlways || CLLocationManager.authorizationStatus() == .authorizedWhenInUse) {
      currentLocation = coreLocationManager.location
      return coreLocationManager.location
    }
    return nil
  }

  //The difference between this function and the one above is requestLocation() immediately returns and will serve the location via the delegate
  open func requestLocation() {
    coreLocationManager.requestLocation()
  }

  open func startUpdatingLocation() {
    coreLocationManager.startUpdatingLocation()
  }

  open func stopUpdatingLocation() {
    coreLocationManager.stopUpdatingLocation()
  }

  //MARK: - CLLocationManagerDelegate

  open func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    switch status {
    case .authorizedAlways:
      delegate?.authorizationDidSucceed?()
    case .authorizedWhenInUse:
      manager.startUpdatingLocation()
      delegate?.authorizationDidSucceed?()
    case .denied:
      delegate?.authorizationDenied?()
    case .restricted:
      delegate?.authorizationRestricted?()
    default:
      print("Not Authorized")
    }
  }

  open func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if let location = locations.last {
      currentLocation = location
      delegate?.locationDidUpdate?(location)
    }
  }

  open func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print("Error from location manager: \(error)")
  }

}
