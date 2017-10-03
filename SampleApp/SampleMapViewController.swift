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
  var selectedMapStyle : StyleSheet = BubbleWrapStyle() {
    didSet {
      do {
        try loadStyleSheetAsync(selectedMapStyle, onStyleLoaded: nil)
      } catch {
        print(error.localizedDescription)
      }
    }
  }
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

//  func setupStyleObservance() {
//    let appDelegate = UIApplication.shared.delegate as! AppDelegate
//    appDelegate.addObserver(self, forKeyPath:
//      #keyPath(AppDelegate.selectedMapStyle), options: .new, context: &myContext)
//  }
//
//  override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//    if context == &myContext {
//      if (change?[.newKey]) != nil {
//        //TODO: We should probably actually check to see what the incoming change is here. However, since we're only observing one thing (mapstyle changes), I leave that as an exercise to the reader.
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        try? loadStyle(appDelegate.selectedMapStyle)
//      }
//    } else {
//      super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
//    }
//  }
//
//  deinit {
//    let appDelegate = UIApplication.shared.delegate as! AppDelegate
//    appDelegate.removeObserver(self, forKeyPath: #keyPath(AppDelegate.selectedMapStyle), context: &myContext)
//  }
}
