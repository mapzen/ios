//
//  TangramVC.swift
//  ios-sdk
//
//  Created by Matt Smollinger on 7/12/16.
//  Copyright © 2016 Mapzen. All rights reserved.
//

import UIKit
import TangramMap
class TangramVC:  MapViewController, MapLoadDelegate, MapSelectDelegate, MapGestureDelegate {

  override func viewDidLoad() {
    super.viewDidLoad()
    self.loadDelegate = self
    self.selectDelegate = self
    self.gestureDelegate = self
    loadSceneFileAsync("scene.yaml")
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  }

  
  //MARK : MapLoadDelegate
  open func mapController(_ controller: MapViewController, didLoadSceneAsync scene: String) {
    showCurrentLocation(true)
    showFindMeButon(true)
    showTestMarker()
  }
  
  //MARK : MapSelectDelegate
  func mapController(_ mapView: MapViewController, didSelectMarker markerPickResult: TGMarkerPickResult?, atScreenPosition position: CGPoint) {
    print("markerPicked")
    let alert = UIAlertController(title: "Marker Selected", message: nil, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
    self.present(alert, animated: true, completion: nil)
  }
  
  //MARK: MapGestureDelegate
  func mapController(_ view: MapViewController, recognizer: UIGestureRecognizer, shouldRecognizeSingleTapGesture location: CGPoint) -> Bool {
    print("Don't Recognize Tap")
    return false
  }
  
  func mapController(_ view: MapViewController, recognizer: UIGestureRecognizer, didRecognizeSingleTapGesture location: CGPoint) {
    print("Map Tapped")
  }
  
  private func showTestMarker() {
    let markerId = markerAdd()
    markerSetStyling(markerId, styling: "{ style: 'points', color: 'white', size: [50px, 50px], order: 2000, collide: false }")
    markerSetPoint(markerId, coordinates: TGGeoPoint())
  }
  
}
