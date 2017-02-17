//
//  TangramVC.swift
//  ios-sdk
//
//  Created by Matt Smollinger on 7/12/16.
//  Copyright © 2016 Mapzen. All rights reserved.
//

import UIKit
import TangramMap
class TangramVC:  MapViewController, MapLoadDelegate {

  override func viewDidLoad() {
    super.viewDidLoad()
    self.loadDelegate = self
    loadSceneFileAsync("scene.yaml")
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  }
  
  //MARK : MapLoadDelegate
  open func mapView(_ controller: MapViewController, didLoadSceneAsync scene: String) {
    showCurrentLocation(true)
    showFindMeButon(true)
  }
  
}
