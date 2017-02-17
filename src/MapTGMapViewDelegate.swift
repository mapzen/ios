//
//  MapTGMapViewDelegate.swift
//  ios-sdk
//
//  Created by Sarah Lensing on 2/16/17.
//  Copyright © 2017 Mapzen. All rights reserved.
//

import Foundation
import TangramMap

class MapTGMapViewDelegate : NSObject, TGMapViewDelegate {
  
  private let mapController : MapViewController
  var loadDelegate : MapLoadDelegate? = nil
  var selectDelegate : MapSelectDelegate? = nil
  
  init(controller : MapViewController) {
    self.mapController = controller
  }
  
  open func mapView(_ mapView: TGMapViewController, didLoadSceneAsync scene: String) {
    guard (loadDelegate != nil) && (self.loadDelegate?.responds(to: #selector(MapLoadDelegate.mapView(_:didLoadSceneAsync:))))! else {
      return
    }
    self.loadDelegate?.mapView!(mapController, didLoadSceneAsync: scene)
  }
  
  open func mapViewDidCompleteLoading(_ mapView: TGMapViewController) {
    guard (self.loadDelegate != nil) && (self.loadDelegate?.responds(to: #selector(MapLoadDelegate.mapViewDidCompleteLoading(_:))))! else {
      return
    }
    self.loadDelegate?.mapViewDidCompleteLoading!(mapController)
  }

  open func mapView(_ mapView: TGMapViewController, didSelectFeature feature: [AnyHashable : Any]?, atScreenPosition position: CGPoint) {
    guard (self.selectDelegate != nil) && (self.selectDelegate?.responds(to: #selector(MapSelectDelegate.mapView(_:didSelectFeature:atScreenPosition:))))! else {
      return
    }
    self.selectDelegate?.mapView!(mapController, didSelectFeature: feature, atScreenPosition: position)
  }
  
  open func mapView(_ mapView: TGMapViewController, didSelectLabel labelPickResult: TGLabelPickResult?, atScreenPosition position: CGPoint) {
    guard (self.selectDelegate != nil) && (self.selectDelegate?.responds(to: #selector(MapSelectDelegate.mapView(_:didSelectLabel:atScreenPosition:))))! else {
      return
    }
    self.selectDelegate?.mapView!(mapController, didSelectLabel: labelPickResult, atScreenPosition: position)
  }
  
  open func mapView(_ mapView: TGMapViewController, didSelectMarker markerPickResult: TGMarkerPickResult?, atScreenPosition position: CGPoint) {
    guard (self.selectDelegate != nil) && (self.selectDelegate?.responds(to: #selector(MapSelectDelegate.mapView(_:didSelectMarker:atScreenPosition:))))! else {
      return
    }
    self.selectDelegate?.mapView!(mapController, didSelectMarker: markerPickResult, atScreenPosition: position)
  }

}
