//
//  MapTGRecognizerDelegate.swift
//  ios-sdk
//
//  Created by Sarah Lensing on 2/17/17.
//  Copyright © 2017 Mapzen. All rights reserved.
//

import Foundation
import TangramMap

class MapTGRecognizerDelegate : NSObject, TGRecognizerDelegate {
    
  private let mapController : MapViewController
  var gestureDelegate : MapGestureDelegate? = nil
    
  init(controller : MapViewController) {
    self.mapController = controller
  }
  
  open func mapView(_ view: TGMapViewController, recognizer: UIGestureRecognizer, shouldRecognizeSingleTapGesture location: CGPoint) -> Bool {
    guard (self.gestureDelegate != nil) else {
      return true
    }
    guard (self.gestureDelegate?.responds(to: #selector(MapGestureDelegate.mapView(_:recognizer:shouldRecognizeSingleTapGesture:))))! else {
      return true
    }
    let recognizeTap = (self.gestureDelegate?.mapView!(mapController, recognizer: recognizer, shouldRecognizeSingleTapGesture: location))!
    if (!recognizeTap) {
      mapController.tgViewController.pickLabel(at: location)
      mapController.tgViewController.pickMarker(at: location)
      mapController.tgViewController.pickFeature(at: location)
    }
    return recognizeTap
  }
  
  open func mapView(_ view: TGMapViewController, recognizer: UIGestureRecognizer, didRecognizeSingleTapGesture location: CGPoint) {
    mapController.tgViewController.pickLabel(at: location)
    mapController.tgViewController.pickMarker(at: location)
    mapController.tgViewController.pickFeature(at: location)
    guard (self.gestureDelegate != nil) else {
      return
    }
    guard (self.gestureDelegate?.responds(to: #selector(MapGestureDelegate.mapView(_:recognizer:didRecognizeSingleTapGesture:))))! else {
      return
    }
    self.gestureDelegate?.mapView!(mapController, recognizer: recognizer, didRecognizeSingleTapGesture: location)
  }
  
  open func mapView(_ view: TGMapViewController, recognizer: UIGestureRecognizer, shouldRecognizeDoubleTapGesture location: CGPoint) -> Bool {
    guard (self.gestureDelegate != nil) else {
      return true
    }
    guard (self.gestureDelegate?.responds(to: #selector(MapGestureDelegate.mapView(_:recognizer:shouldRecognizeDoubleTapGesture:))))! else {
      return true
    }
    return ((self.gestureDelegate?.mapView!(mapController, recognizer: recognizer, shouldRecognizeDoubleTapGesture: location))!)
  }
  
  open func mapView(_ view: TGMapViewController, recognizer: UIGestureRecognizer, didRecognizeDoubleTapGesture location: CGPoint) {
    guard (self.gestureDelegate != nil) else {
      return
    }
    guard (self.gestureDelegate?.responds(to: #selector(MapGestureDelegate.mapView(_:recognizer:didRecognizeDoubleTapGesture:))))! else {
      return
    }
    self.gestureDelegate?.mapView!(mapController, recognizer: recognizer, didRecognizeDoubleTapGesture: location)
  }
  
  open func mapView(_ view: TGMapViewController, recognizer: UIGestureRecognizer, shouldRecognizeLongPressGesture location: CGPoint) -> Bool {
    guard (self.gestureDelegate != nil) else {
      return true
    }
    guard (self.gestureDelegate?.responds(to: #selector(MapGestureDelegate.mapView(_:recognizer:shouldRecognizeLongPressGesture:))))! else {
      return true
    }
    return (self.gestureDelegate?.mapView!(mapController, recognizer: recognizer, shouldRecognizeLongPressGesture: location))!
  }
  
  open func mapView(_ view: TGMapViewController, recognizer: UIGestureRecognizer, didRecognizeLongPressGesture location: CGPoint) {
    guard (self.gestureDelegate != nil) else {
      return
    }
    guard (self.gestureDelegate?.responds(to: #selector(MapGestureDelegate.mapView(_:recognizer:didRecognizeLongPressGesture:))))! else {
      return
    }
    self.gestureDelegate?.mapView!(mapController, recognizer: recognizer, didRecognizeLongPressGesture: location)
  }
  
  open func mapView(_ view: TGMapViewController, recognizer: UIGestureRecognizer, shouldRecognizePanGesture displacement: CGPoint) -> Bool {
    guard (self.gestureDelegate != nil) else {
      return true
    }
    guard (self.gestureDelegate?.responds(to: #selector(MapGestureDelegate.mapView(_:recognizer:shouldRecognizePanGesture:))))! else {
      return true
    }
    let recognizePan = (self.gestureDelegate?.mapView!(mapController, recognizer: recognizer, shouldRecognizePanGesture: displacement))!
    if (!recognizePan) {
      mapController.shouldFollowCurrentLocation = false
      mapController.findMeButton.isSelected = false
    }
    return recognizePan
  }
  
  open func mapView(_ view: TGMapViewController, recognizer: UIGestureRecognizer, didRecognizePanGesture location: CGPoint) {
    mapController.shouldFollowCurrentLocation = false
    mapController.findMeButton.isSelected = false
    guard (self.gestureDelegate != nil) else {
      return
    }
    guard (self.gestureDelegate?.responds(to: #selector(MapGestureDelegate.mapView(_:recognizer:didRecognizePanGesture:))))! else {
      return
    }
    self.gestureDelegate?.mapView!(mapController, recognizer: recognizer, didRecognizePanGesture: location)
  }
  
  open func mapView(_ view: TGMapViewController, recognizer: UIGestureRecognizer, shouldRecognizePinchGesture location: CGPoint) -> Bool {
    guard (self.gestureDelegate != nil) else {
      return true
    }
    guard (self.gestureDelegate?.responds(to: #selector(MapGestureDelegate.mapView(_:recognizer:shouldRecognizePinchGesture:))))! else {
      return true
    }
    return (self.gestureDelegate?.mapView!(mapController, recognizer: recognizer, shouldRecognizePinchGesture: location))!
  }
  
  open func mapView(_ view: TGMapViewController, recognizer: UIGestureRecognizer, didRecognizePinchGesture location: CGPoint) {
    guard (self.gestureDelegate != nil) else {
      return
    }
    guard (self.gestureDelegate?.responds(to: #selector(MapGestureDelegate.mapView(_:recognizer:didRecognizePinchGesture:))))! else {
      return
    }
    self.gestureDelegate?.mapView!(mapController, recognizer: recognizer, didRecognizePinchGesture: location)
  }
  
  open func mapView(_ view: TGMapViewController, recognizer: UIGestureRecognizer, shouldRecognizeRotationGesture location: CGPoint) -> Bool {
    guard (self.gestureDelegate != nil) else {
      return true
    }
    guard (self.gestureDelegate?.responds(to: #selector(MapGestureDelegate.mapView(_:recognizer:shouldRecognizeRotationGesture:))))! else {
      return true
    }
    return (self.gestureDelegate?.mapView!(mapController, recognizer: recognizer, shouldRecognizeRotationGesture: location))!
  }
  
  open func mapView(_ view: TGMapViewController, recognizer: UIGestureRecognizer, didRecognizeRotationGesture location: CGPoint) {
    guard (self.gestureDelegate != nil) else {
      return
    }
    guard (self.gestureDelegate?.responds(to: #selector(MapGestureDelegate.mapView(_:recognizer:didRecognizeRotationGesture:))))! else {
      return
    }
    self.gestureDelegate?.mapView!(mapController, recognizer: recognizer, didRecognizeRotationGesture: location)
  }
  
  open func mapView(_ view: TGMapViewController, recognizer: UIGestureRecognizer, shouldRecognizeShoveGesture displacement: CGPoint) -> Bool {
    guard (self.gestureDelegate != nil) else {
      return true
    }
    guard (self.gestureDelegate?.responds(to: #selector(MapGestureDelegate.mapView(_:recognizer:shouldRecognizeShoveGesture:))))! else {
      return true
    }
    return (self.gestureDelegate?.mapView!(mapController, recognizer: recognizer, shouldRecognizeShoveGesture: displacement))!
  }
  
  open func mapView(_ view: TGMapViewController, recognizer: UIGestureRecognizer, didRecognizeShoveGesture displacement: CGPoint) {
    guard (self.gestureDelegate != nil) else {
      return
    }
    guard (self.gestureDelegate?.responds(to: #selector(MapGestureDelegate.mapView(_:recognizer:didRecognizeShoveGesture:))))! else {
      return
    }
    self.gestureDelegate?.mapView!(mapController, recognizer: recognizer, didRecognizeShoveGesture: displacement)
  }

}
