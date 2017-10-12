//
//  SampleMapViewController.swift
//  ios-sdk
//
//  Created by Sarah Lensing on 3/13/17.
//  Copyright © 2017 Mapzen. All rights reserved.
//

import CoreLocation
import UIKit
import Mapzen_ios_sdk

class SampleMapViewController : MZMapViewController {

  var firstTimeZoomToCurrentLocation = true
  var sceneDidLoad = false
  private var myContext = 0

  override var prefersStatusBarHidden: Bool {
    return false
  }

  func shouldZoomToCurrentLocation() {
    if !sceneDidLoad { return }
    if !receivedLocation() { return }
    _ = resetCameraOnCurrentLocation()
    firstTimeZoomToCurrentLocation = false
  }

  //MARK:- Location Delegate Overrides
  override func locationDidUpdate(_ location: CLLocation) {
    super.locationDidUpdate(location)
    if (firstTimeZoomToCurrentLocation) {
      shouldZoomToCurrentLocation()
    }
  }

  //Notification for MapStyle changes
  func setupStyleNotification() {
    NotificationCenter.default.addObserver(self, selector: #selector(reloadMap), name: AppDelegate.MapUpdateNotification, object: nil)
  }

  @objc func reloadMap() {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    try? loadStyleSheet(appDelegate.selectedMapStyle)
  }

  deinit {
    NotificationCenter.default.removeObserver(self)
  }
}
