//
//  TangramVC.swift
//  ios-sdk
//
//  Created by Matt Smollinger on 7/12/16.
//  Copyright © 2016 Mapzen. All rights reserved.
//

import UIKit
import TangramMap
class TangramVC:  MapViewController, MapMarkerSelectDelegate {

  override func viewDidLoad() {
    super.viewDidLoad()
    markerSelectDelegate = self
    loadSceneFileAsync("scene.yaml") { (scene) in
      let _ = self.showCurrentLocation(true)
      self.showFindMeButon(true)
      self.showTestMarker()
    }
  }
  
  //MARK : MapSelectDelegate  
  func mapController(_ controller: MapViewController, didSelectMarker markerPickResult: TGMarkerPickResult?, atScreenPosition position: CGPoint) {
    print("markerPicked")
    let alert = UIAlertController(title: "Marker Selected", message: nil, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
    present(alert, animated: true, completion: nil)
  }

  private func showTestMarker() {
    let markerId = markerAdd()
    let _ = markerSetStyling(markerId, styling: "{ style: 'points', color: 'white', size: [50px, 50px], collide: false, interactive: true }")
    let _ = markerSetPoint(markerId, coordinates: TGGeoPoint())
  }
  
}
