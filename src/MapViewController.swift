//
//  MapViewController.swift
//  ios-sdk
//
//  Created by Matt Smollinger on 11/21/16.
//  Copyright © 2016 Mapzen. All rights reserved.
//


import UIKit
import TangramMap
import CoreLocation
import Pelias
import OnTheRoad

@objc public enum MZError: Int {
  case generalError, annotationDoesNotExist, apiKeyNotSet, routeDoesNotExist
}

open class MapViewController: TGMapViewController, LocationManagerDelegate, TGRecognizerDelegate {

  //Error Domains for NSError Appeasement
  open static let MapzenGeneralErrorDomain = "MapzenGeneralErrorDomain"

  open var tgViewController: TGMapViewController = TGMapViewController()
  var currentLocationGem: TGMapMarkerId?
  var lastSetPoint: TGGeoPoint?
  var shouldShowCurrentLocation = false
  var currentRouteMarker: TGMapMarkerId?
  open var shouldFollowCurrentLocation = false
  open var findMeButton = UIButton(type: .custom)
  open var currentAnnotations: [PeliasMapkitAnnotation : TGMapMarkerId] = Dictionary()

  public var cameraType: TGCameraType {
    set {
      tgViewController.cameraType = cameraType
    }
    get {
      return tgViewController.cameraType
    }
  }
  
  public var position: TGGeoPoint {
    set {
      tgViewController.position = position
    }
    get {
      return tgViewController.position
    }
  }
  
  public var zoom: Float {
    set {
      tgViewController.zoom = zoom
    }
    get {
      return tgViewController.zoom
    }
  }
  
  public var rotation: Float {
    set {
      tgViewController.rotation = rotation
    }
    get {
      return tgViewController.rotation
    }
  }
  
  public var tilt: Float {
    set {
      tgViewController.tilt = tilt
    }
    get {
      return tgViewController.tilt
    }
  }

  init(){
    super.init(nibName: nil, bundle: nil)
    defer {
      findMeButton = createFindMeButton()
    }
  }

  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    defer {
      findMeButton = createFindMeButton()
    }
  }

  public func animateToPosition(position: TGGeoPoint, withDuration seconds: Float) {
    tgViewController.animateToPosition(position, withDuration: seconds)
  }
  
  public func animateToPosition(position: TGGeoPoint, withDuration seconds: Float, withEaseType easeType: TGEaseType) {
    tgViewController.animateToPosition(position, withDuration: seconds, withEaseType: easeType)
  }
  
  public func animateToZoomLevel(zoomLevel: Float, withDuration seconds: Float) {
    tgViewController.animateToZoomLevel(zoomLevel, withDuration: seconds)
  }
  
  public func animateToZoomLevel(zoomLevel: Float, withDuration seconds: Float, withEaseType easeType: TGEaseType) {
    tgViewController.animateToZoomLevel(zoomLevel, withDuration: seconds, withEaseType: easeType)
  }
  
  public func animateToRotation(radians: Float, withDuration seconds: Float) {
    tgViewController.animateToRotation(radians, withDuration: seconds)
  }
  
  public func animateToRotation(radians: Float, withDuration seconds: Float, withEaseType easeType: TGEaseType) {
    tgViewController.animateToRotation(radians, withDuration: seconds, withEaseType: easeType)
  }
  
  public func animateToTilt(radians: Float, withDuration seconds: Float) {
    tgViewController.animateToTilt(radians, withDuration: seconds)
  }
  
  public func animateToTilt(radians: Float, withDuration seconds: Float, withEaseType easeType: TGEaseType) {
    tgViewController.animateToTilt(radians, withDuration: seconds, withEaseType: easeType)
  }
  
  public func markerRemoveAll() {
    tgViewController.markerRemoveAll()
  }
  
  public func markerAdd() -> TGMapMarkerId {
    return tgViewController.markerAdd()
  }
  
  public func markerSetStyling(identifier: TGMapMarkerId, styling: String) -> Bool {
    return tgViewController.markerSetStyling(identifier, styling: styling)
  }
  
  public func markerSetPoint(identifier: TGMapMarkerId, coordinates coordinate: TGGeoPoint) -> Bool {
    return tgViewController.markerSetPoint(identifier, coordinates: coordinate)
  }
  
  public func markerSetPointEased(identifier: TGMapMarkerId, coordinates coordinate: TGGeoPoint, duration: Float, easeType ease: TGEaseType) -> Bool {
    return tgViewController.markerSetPointEased(identifier, coordinates: coordinate, duration: duration, easeType: ease)
  }
  
  public func markerSetPolyline(identifier: TGMapMarkerId, polyline: TGGeoPolyline) -> Bool {
    return tgViewController.markerSetPolyline(identifier, polyline: polyline)
  }
  
  public func markerSetPolygon(identifier: TGMapMarkerId, polygon: TGGeoPolygon) -> Bool {
    return tgViewController.markerSetPolygon(identifier, polygon: polygon)
  }
  
  public func markerSetVisible(identifier: TGMapMarkerId, visible: Bool) -> Bool {
    return tgViewController.markerSetVisible(identifier, visible: visible)
  }
  
  public func markerSetImage(identifier: TGMapMarkerId, image: UIImage) -> Bool {
    return tgViewController.markerSetImage(identifier, image: image)
  }
  
  public func markerRemove(marker: TGMapMarkerId) -> Bool {
    return tgViewController.markerRemove(marker)
  }
  
  public func loadSceneFile(path: String) {
    tgViewController.loadSceneFile(path)
  }
  
  public func loadSceneFile(path: String, sceneUpdates: [TGSceneUpdate]) {
    tgViewController.loadSceneFile(path, sceneUpdates: sceneUpdates)
  }
  
  public func loadSceneFileAsync(path: String) {
    tgViewController.loadSceneFileAsync(path)
  }
  
  public func loadSceneFileAsync(path: String, sceneUpdates: [TGSceneUpdate]) {
    tgViewController.loadSceneFileAsync(path, sceneUpdates: sceneUpdates)
  }
  
  public func queueSceneUpdate(componentPath: String, withValue value: String) {
    tgViewController.queueSceneUpdate(componentPath, withValue: value)
  }
  
  public func queueSceneUpdates(sceneUpdates: [TGSceneUpdate]) {
    tgViewController.queueSceneUpdates(sceneUpdates)
  }
  
  public func applySceneUpdates() {
    tgViewController.applySceneUpdates()
  }
  
  public func lngLatToScreenPosition(lngLat: TGGeoPoint) -> CGPoint {
    return tgViewController.lngLatToScreenPosition(lngLat)
  }
  
  public func screenPositionToLngLat(screenPosition: CGPoint) -> TGGeoPoint {
    return tgViewController.screenPositionToLngLat(screenPosition)
  }
  
  //! Returns whether or not the map was centered on the device's current location
  open func resetCameraOnCurrentLocation(_ tilt: Float = 0.0, zoomLevel: Float = 16.0, animationDuration: Float = 1.0) -> Bool {
    guard let marker = currentLocationGem else { return false }
    guard let point = lastSetPoint else { return false }
    if marker == 0 { return false } // Invalid Marker
    tgViewController.animateToZoomLevel(zoomLevel, withDuration: animationDuration)
    tgViewController.animateToPosition(point, withDuration: animationDuration)
    tgViewController.animateToTilt(tilt, withDuration: animationDuration)
    return true
  }

  //! Handles state for the find me button
  open func showFindMeButon(_ shouldShow: Bool) {
    findMeButton.isHidden = !shouldShow
    findMeButton.isEnabled = shouldShow
  }

  //! Returns whether or not current location was shown
  open func showCurrentLocation(_ shouldShow: Bool) -> Bool {
    shouldShowCurrentLocation = shouldShow
    guard let marker = currentLocationGem else {
      let marker = tgViewController.markerAdd()
      if marker == 0 { return false } // Didn't initialize correctly.
      currentLocationGem = marker;
      LocationManager.sharedManager.requestWhenInUseAuthorization()
      tgViewController.markerSetStyling(marker, styling: "{ style: ux-location-gem-overlay, sprite: ux-current-location, size: 36px, collide: false }")
      //Set visibility to false since we have to wait until we have an accurate location
      tgViewController.markerSetVisible(marker, visible: false)
      return true
    }
    tgViewController.markerSetVisible(marker, visible: shouldShowCurrentLocation)
    return true
  }

  open func enableLocationLayer(_ enabled: Bool) {
    showCurrentLocation(enabled)
    showFindMeButon(enabled)
    enabled ? LocationManager.sharedManager.startUpdatingLocation() : LocationManager.sharedManager.stopUpdatingLocation()
    shouldFollowCurrentLocation = enabled
  }

  open func loadScene(named: String, apiKey: String? = nil) throws {
    tgViewController.loadSceneFile(named)
    if let apiKey = apiKey {
      tgViewController.queueSceneUpdate("sources.mapzen.url_params", withValue: "{ api_key: \(apiKey)}")
    } else {
      if let apiKey = MapzenManager.sharedManager.apiKey {
        tgViewController.queueSceneUpdate("sources.mapzen.url_params", withValue: "{ api_key: \(apiKey)}")

      } else {
        throw NSError(domain: MapViewController.MapzenGeneralErrorDomain,
                      code: MZError.apiKeyNotSet.rawValue,
                      userInfo: nil)
      }
    }
    tgViewController.applySceneUpdates()
  }

  open func add(_ annotations: [PeliasMapkitAnnotation]) throws {
    for annotation in annotations {
      let newMarker = tgViewController.markerAdd()
      if newMarker == 0 {
        //TODO: Once TG integrates better error codes, we need to integrate that here.
        // https://github.com/tangrams/tangram-es/issues/1219
        throw NSError(domain: MapViewController.MapzenGeneralErrorDomain,
                      code: MZError.generalError.rawValue,
                      userInfo: nil)
      }
      tgViewController.markerSetPoint(newMarker, coordinates: TGGeoPoint(coordinate: annotation.coordinate))
      tgViewController.markerSetStyling(newMarker, styling: "{ style: sdk-point-overlay, sprite: ux-search-active, size: [24, 36px], collide: false }")
      currentAnnotations[annotation] = newMarker

    }
  }

  open func remove(_ annotation: PeliasMapkitAnnotation) throws {
    guard let markerId = currentAnnotations[annotation] else { return }
    if !tgViewController.markerRemove(markerId) {
      throw NSError(domain: MapViewController.MapzenGeneralErrorDomain,
                    code: MZError.annotationDoesNotExist.rawValue,
                    userInfo: nil)
    }
    currentAnnotations.removeValue(forKey: annotation)
  }

  open func removeAnnotations() throws {
    for (annotation, markerId) in currentAnnotations {
      if !tgViewController.markerRemove(markerId) {
        throw NSError(domain: MapViewController.MapzenGeneralErrorDomain,
                      code: MZError.annotationDoesNotExist.rawValue,
                      userInfo: nil)
      }
      currentAnnotations.removeValue(forKey: annotation)
    }
  }

  open func display(_ route: OTRRoutingResult) throws {
    //TODO: We eventually should support N number of routes.
    if let routeMarker = currentRouteMarker {
      //We don't throw if the remove fails here because we want to silently replace the route
      currentRouteMarker = nil
      tgViewController.markerRemove(routeMarker)
    }
    let routeLeg = route.legs[0]
    let polyLine = TGGeoPolyline(size: UInt32(routeLeg.coordinateCount))

    //TODO: Need to investigate more if this is a bug in OTR or if valhalla returns null island at the end of their requests?
    for index in 0...routeLeg.coordinateCount-1 {
      let point = routeLeg.coordinates?[Int(index)]
      print("Next Point: \(point)")
      polyLine?.add(TGGeoPoint(coordinate: point!))
    }
    let marker = tgViewController.markerAdd()
    if marker == 0 {
      throw NSError(domain: MapViewController.MapzenGeneralErrorDomain,
                    code: MZError.generalError.rawValue,
                    userInfo: nil)
    }
    tgViewController.markerSetStyling(marker, styling: "{ style: ux-route-line-overlay, color: '#06a6d4',  width: [[0,3.5px],[5,5px],[9,7px],[10,6px],[11,6px],[13,8px],[14,9px],[15,10px],[16,11px],[17,12px],[18,10px]], order: 500 }")
    tgViewController.markerSetPolyline(marker, polyline: polyLine)
    currentRouteMarker = marker
  }

  open func removeRoute() throws {

    guard let currentRouteMarker = currentRouteMarker else {
      throw NSError(domain: MapViewController.MapzenGeneralErrorDomain,
                    code: MZError.routeDoesNotExist.rawValue,
                    userInfo: nil)
    }

    if !tgViewController.markerRemove(currentRouteMarker) {
      throw NSError(domain: MapViewController.MapzenGeneralErrorDomain,
                    code: MZError.routeDoesNotExist.rawValue,
                    userInfo: nil)
    }
    self.currentRouteMarker = nil
  }

  @objc func defaultFindMeAction(_ button: UIButton, touchEvent: UIEvent) {
    resetCameraOnCurrentLocation()
    button.isSelected = !button.isSelected
    shouldFollowCurrentLocation = button.isSelected
  }

  override open func viewDidLoad() {
    super.viewDidLoad()
    LocationManager.sharedManager.delegate = self
    
    self.view.addSubview(tgViewController.view)
    
    tgViewController.gestureDelegate = self
  }

  override open func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
    tgViewController.viewWillTransitionToSize(size, withTransitionCoordinator:coordinator)
  }
    
  override open func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    let viewRect = view.bounds
    findMeButton.frame = CGRect(x: viewRect.width - 60.0, y: viewRect.height - 100.0, width: CGFloat(48), height: CGFloat(48))
    view.addSubview(findMeButton)
    findMeButton.sizeToFit()
  }

  func createFindMeButton() -> UIButton {
    let findMeButton = UIButton(type: UIButtonType.custom)
    findMeButton.addTarget(self, action: #selector(MapViewController.defaultFindMeAction(_:touchEvent:)), for: .touchUpInside)
    findMeButton.isEnabled = false
    findMeButton.isHidden = true
    findMeButton.adjustsImageWhenHighlighted = false
    findMeButton.setBackgroundImage(UIImage(named: "ic_find_me_normal"), for: UIControlState())
    //TODO: This should also have .Highlighted as well .Selected , but something about the @3x assets and UIButton is misbehaving; might need bug opened with Apple.
    findMeButton.setBackgroundImage(UIImage(named: "ic_find_me_pressed"), for: [.selected])
    findMeButton.backgroundColor = UIColor.white
    findMeButton.autoresizingMask = [.flexibleTopMargin, .flexibleLeftMargin]
    return findMeButton
  }

  //MARK: - LocationManagerDelegate

  open func locationDidUpdate(_ location: CLLocation) {
    guard let marker = currentLocationGem else {
      return
    }
    lastSetPoint = TGGeoPoint(longitude: location.coordinate.longitude, latitude: location.coordinate.latitude)
    tgViewController.markerSetPoint(marker, coordinates: TGGeoPoint(longitude: location.coordinate.longitude, latitude: location.coordinate.latitude))
    if (shouldShowCurrentLocation) {
      tgViewController.markerSetVisible(marker, visible: true)
    }

    if (shouldFollowCurrentLocation) {
      print("Updating for current lat: \(location.coordinate.latitude) & long: \(location.coordinate.longitude)")
      resetCameraOnCurrentLocation()
    }
  }

  open func authorizationDidSucceed() {
    LocationManager.sharedManager.startUpdatingLocation()
    LocationManager.sharedManager.requestLocation()
  }

  open func authorizationDenied() {
    failedLocationAuthorization()
  }

  open func authorizationRestricted() {
    //For our uses, this is effectively the same handling as denied location authorization
    failedLocationAuthorization()
  }

  func failedLocationAuthorization() {
    shouldShowCurrentLocation = false
    guard let marker = currentLocationGem else { return }
    tgViewController.markerRemove(marker)
    return
  }

  //MARK: - TGRecognizerDelegate

  open func mapView(_ view: TGMapViewController, recognizer: UIGestureRecognizer, didRecognizePanGesture location: CGPoint) {
    shouldFollowCurrentLocation = false
    findMeButton.isSelected = false
  }
}
