//
//  TestTGMapViewController.swift
//  ios-sdk
//
//  Created by Sarah Lensing on 2/15/17.
//  Copyright © 2017 Mapzen. All rights reserved.
//

import Foundation
import TangramMap

class TestTGMapViewController: TGMapViewController {
  
  var removedAllMarkers = false
  var coordinate = TGGeoPoint()
  var duration: Float = 0.0
  var easeType = TGEaseType.cubic
  var scenePath = URL(fileURLWithPath: "")
  var sceneUpdates: [TGSceneUpdate] = []
  var sceneUpdateComponentPath = ""
  var sceneUpdateValue = ""
  var appliedSceneUpdates = false
  var lngLatForScreenPosition = TGGeoPoint()
  var screenPositionForLngLat = CGPoint()
  var labelPickPosition = CGPoint()
  var markerPickPosition = CGPoint()
  var featurePickPosition = CGPoint()
  
  override func markerRemoveAll() {
    removedAllMarkers = true
  }

  override func loadScene(from url: URL) -> Int32 {
    scenePath = url
    return 0
  }

  override func loadScene(from url: URL, with updates: [TGSceneUpdate]) -> Int32 {
    scenePath = url
    sceneUpdates = updates
    return 0
  }

  override func loadSceneAsync(from url: URL) -> Int32 {
    scenePath = url
    return 0
  }

  override func loadSceneAsync(from url: URL, with updates: [TGSceneUpdate]) -> Int32 {
    scenePath = url
    sceneUpdates = updates
    return 0
  }

  override func updateSceneAsync(_ updates: [TGSceneUpdate]) -> Int32 {
    sceneUpdates = updates
    appliedSceneUpdates = true
    return 0
  }
  
  override func lngLat(toScreenPosition lngLat: TGGeoPoint) -> CGPoint {
    lngLatForScreenPosition = lngLat
    return CGPoint()
  }
  
  override func screenPosition(toLngLat screenPosition: CGPoint) -> TGGeoPoint {
    screenPositionForLngLat = screenPosition
    return TGGeoPoint()
  }
  
  override func animate(toPosition position: TGGeoPoint, withDuration seconds: Float) {
    coordinate = position
    duration = seconds
  }
  
  override func animate(toPosition position: TGGeoPoint, withDuration seconds: Float, with easeType: TGEaseType) {
    coordinate = position
    duration = seconds
    self.easeType = easeType
  }
  
  override func animate(toZoomLevel zoomLevel: Float, withDuration seconds: Float) {
    zoom = zoomLevel
    duration = seconds
  }
  
  override func animate(toZoomLevel zoomLevel: Float, withDuration seconds: Float, with easeType: TGEaseType) {
    zoom = zoomLevel
    duration = seconds
    self.easeType = easeType
  }
  
  override func animate(toRotation radians: Float, withDuration seconds: Float) {
    rotation = radians
    duration = seconds
  }
  
  override func animate(toRotation radians: Float, withDuration seconds: Float, with easeType: TGEaseType) {
    rotation = radians
    duration = seconds
    self.easeType = easeType
  }
  
  override func animate(toTilt radians: Float, withDuration seconds: Float) {
    tilt = radians
    duration = seconds
  }
  
  override func animate(toTilt radians: Float, withDuration seconds: Float, with easeType: TGEaseType) {
    tilt = radians
    duration = seconds
    self.easeType = easeType
  }

  override func pickLabel(at screenPosition: CGPoint) {
    labelPickPosition = screenPosition
  }
  
  override func pickMarker(at screenPosition: CGPoint) {
    markerPickPosition = screenPosition
  }
  
  override func pickFeature(at screenPosition: CGPoint) {
    featurePickPosition = screenPosition
  }
}
