//
//  TangramVC.swift
//  ios-sdk
//
//  Created by Matt Smollinger on 7/12/16.
//  Copyright © 2016 Mapzen. All rights reserved.
//

import UIKit
import TangramMap
class TangramVC:  MapViewController{

  override func viewDidLoad() {
    super.viewDidLoad()
    let _ = try? loadScene("scene.yaml", apiKey: "mapzen-2qQR7SX")
  }

  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    showCurrentLocation(true)
    showFindMeButon(true)
  }
}
