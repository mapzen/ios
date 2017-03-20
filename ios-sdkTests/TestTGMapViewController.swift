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
  var scenePath = ""
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
  
  override func loadSceneFile(_ path: String) {
    self.scenePath = path
  }
  
  override func loadSceneFile(_ path: String, sceneUpdates: [TGSceneUpdate]) {
    self.scenePath = path
    self.sceneUpdates = sceneUpdates
  }
  
  override func loadSceneFileAsync(_ path: String) {
    self.scenePath = path
  }
  
  override func loadSceneFileAsync(_ path: String, sceneUpdates: [TGSceneUpdate]) {
    self.scenePath = path
    self.sceneUpdates = sceneUpdates
  }
  
  override func queueSceneUpdate(_ componentPath: String, withValue value: String) {
    self.sceneUpdateComponentPath = componentPath
    self.sceneUpdateValue = value
  }
  
  override func queue(_ sceneUpdates: [TGSceneUpdate]) {
    self.sceneUpdates = sceneUpdates
  }
  
  override func applySceneUpdates() {
    self.appliedSceneUpdates = true
  }
  
  override func lngLat(toScreenPosition lngLat: TGGeoPoint) -> CGPoint {
    self.lngLatForScreenPosition = lngLat
    return CGPoint()
  }
  
  override func screenPosition(toLngLat screenPosition: CGPoint) -> TGGeoPoint {
    self.screenPositionForLngLat = screenPosition
    return TGGeoPoint()
  }
  
  override func animate(toPosition position: TGGeoPoint, withDuration seconds: Float) {
    self.coordinate = position
    self.duration = seconds
  }
  
  override func animate(toPosition position: TGGeoPoint, withDuration seconds: Float, with easeType: TGEaseType) {
    self.coordinate = position
    self.duration = seconds
    self.easeType = easeType
  }
  
  override func animate(toZoomLevel zoomLevel: Float, withDuration seconds: Float) {
    self.zoom = zoomLevel
    self.duration = seconds
  }
  
  override func animate(toZoomLevel zoomLevel: Float, withDuration seconds: Float, with easeType: TGEaseType) {
    self.zoom = zoomLevel
    self.duration = seconds
    self.easeType = easeType
  }
  
  override func animate(toRotation radians: Float, withDuration seconds: Float) {
    self.rotation = radians
    self.duration = seconds
  }
  
  override func animate(toRotation radians: Float, withDuration seconds: Float, with easeType: TGEaseType) {
    self.rotation = radians
    self.duration = seconds
    self.easeType = easeType
  }
  
  override func animate(toTilt radians: Float, withDuration seconds: Float) {
    self.tilt = radians
    self.duration = seconds
  }
  
  override func animate(toTilt radians: Float, withDuration seconds: Float, with easeType: TGEaseType) {
    self.tilt = radians
    self.duration = seconds
    self.easeType = easeType
  }

  override func pickLabel(at screenPosition: CGPoint) {
    self.labelPickPosition = screenPosition
  }
  
  override func pickMarker(at screenPosition: CGPoint) {
    self.markerPickPosition = screenPosition
  }
  
  override func pickFeature(at screenPosition: CGPoint) {
    self.featurePickPosition = screenPosition
  }
}
