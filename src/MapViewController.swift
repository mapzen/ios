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

public protocol MapSingleTapGestureDelegate : class {
  func mapController(_ controller: MapViewController, recognizer: UIGestureRecognizer, shouldRecognizeSingleTapGesture location: CGPoint) -> Bool
  func mapController(_ controller: MapViewController, recognizer: UIGestureRecognizer, didRecognizeSingleTapGesture location: CGPoint)
}

public protocol MapDoubleTapGestureDelegate : class {
  func mapController(_ controller: MapViewController, recognizer: UIGestureRecognizer, shouldRecognizeDoubleTapGesture location: CGPoint) -> Bool
  func mapController(_ controller: MapViewController, recognizer: UIGestureRecognizer, didRecognizeDoubleTapGesture location: CGPoint)
}

public protocol MapLongPressGestureDelegate : class {
  func mapController(_ controller: MapViewController, recognizer: UIGestureRecognizer, shouldRecognizeLongPressGesture location: CGPoint) -> Bool
  func mapController(_ controller: MapViewController, recognizer: UIGestureRecognizer, didRecognizeLongPressGesture location: CGPoint)
}

public protocol MapPanGestureDelegate : class {
  func mapController(_ controller: MapViewController, didPanMap displacement: CGPoint)
}

public protocol MapPinchGestureDelegate : class {
  func mapController(_ controller: MapViewController, didPinchMap location: CGPoint)
}

public protocol MapRotateGestureDelegate : class {
  func mapController(_ controller: MapViewController, didRotateMap location: CGPoint)
}

public protocol MapShoveGestureDelegate : class {
  func mapController(_ controller: MapViewController, didShoveMap displacement: CGPoint)
}

public protocol MapFeatureSelectDelegate : class {
  func mapController(_ controller: MapViewController, didSelectFeature feature: [AnyHashable : Any]?, atScreenPosition position: CGPoint)
}

public protocol MapLabelSelectDelegate : class {
  func mapController(_ controller: MapViewController, didSelectLabel labelPickResult: TGLabelPickResult?, atScreenPosition position: CGPoint)
}

public protocol MapMarkerSelectDelegate : class {
  func mapController(_ controller: MapViewController, didSelectMarker markerPickResult: TGMarkerPickResult?, atScreenPosition position: CGPoint)
}

public protocol MapTileLoadDelegate : class {
  func mapControllerDidCompleteLoading(_ controller: MapViewController)
}

open class MapViewController: UIViewController, LocationManagerDelegate {

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

  open var cameraType: TGCameraType {
    set {
      tgViewController.cameraType = cameraType
    }
    get {
      return tgViewController.cameraType
    }
  }
  
  open var position: TGGeoPoint {
    set {
      tgViewController.position = position
    }
    get {
      return tgViewController.position
    }
  }
  
  open var zoom: Float {
    set {
      tgViewController.zoom = zoom
    }
    get {
      return tgViewController.zoom
    }
  }
  
  open var rotation: Float {
    set {
      tgViewController.rotation = rotation
    }
    get {
      return tgViewController.rotation
    }
  }
  
  open var tilt: Float {
    set {
      tgViewController.tilt = tilt
    }
    get {
      return tgViewController.tilt
    }
  }
  
  open var panEnabled = true
  open var pinchEnabled = true
  open var rotateEnabled = true
  open var shoveEnabled = true
  
  weak open var singleTapGestureDelegate: MapSingleTapGestureDelegate?
  weak open var doubleTapGestureDelegate: MapDoubleTapGestureDelegate?
  weak open var longPressGestureDelegate: MapLongPressGestureDelegate?
  weak open var panDelegate: MapPanGestureDelegate?
  weak open var pinchDelegate: MapPinchGestureDelegate?
  weak open var rotateDelegate: MapRotateGestureDelegate?
  weak open var shoveDelegate: MapShoveGestureDelegate?
  weak open var featureSelectDelegate: MapFeatureSelectDelegate?
  weak open var labelSelectDelegate: MapLabelSelectDelegate?
  weak open var markerSelectDelegate: MapMarkerSelectDelegate?
  weak open var tileLoadDelegate: MapTileLoadDelegate?

  public typealias OnSceneLoaded = (String) -> ()
  fileprivate var onSceneLoadedClosure : OnSceneLoaded? = nil

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

  open func animate(toPosition position: TGGeoPoint, withDuration seconds: Float) {
    tgViewController.animate(toPosition: position, withDuration: seconds)
  }
  
  open func animate(toPosition position: TGGeoPoint, withDuration seconds: Float, with easeType: TGEaseType) {
    tgViewController.animate(toPosition: position, withDuration: seconds, with: easeType)
  }
  
  open func animate(toZoomLevel zoomLevel: Float, withDuration seconds: Float) {
    tgViewController.animate(toZoomLevel: zoomLevel, withDuration: seconds)
  }
  
  open func animate(toZoomLevel zoomLevel: Float, withDuration seconds: Float, with easeType: TGEaseType) {
    tgViewController.animate(toZoomLevel: zoomLevel, withDuration: seconds, with: easeType)
  }
  
  open func animate(toRotation radians: Float, withDuration seconds: Float) {
    tgViewController.animate(toRotation: radians, withDuration: seconds)
  }
  
  open func animate(toRotation radians: Float, withDuration seconds: Float, with easeType: TGEaseType) {
    tgViewController.animate(toRotation: radians, withDuration: seconds, with: easeType)
  }
  
  open func animate(toTilt radians: Float, withDuration seconds: Float) {
    tgViewController.animate(toTilt: radians, withDuration: seconds)
  }
  
  open func animate(toTilt radians: Float, withDuration seconds: Float, with easeType: TGEaseType) {
    tgViewController.animate(toTilt: radians, withDuration: seconds, with: easeType)
  }
  
  open func markerRemoveAll() {
    tgViewController.markerRemoveAll()
  }
  
  open func markerAdd() -> TGMapMarkerId {
    return tgViewController.markerAdd()
  }
  
  open func markerSetStyling(_ identifier: TGMapMarkerId, styling: String) -> Bool {
    return tgViewController.markerSetStyling(identifier, styling: styling)
  }
  
  open func markerSetPoint(_ identifier: TGMapMarkerId, coordinates coordinate: TGGeoPoint) -> Bool {
    return tgViewController.markerSetPoint(identifier, coordinates: coordinate)
  }
  
  open func markerSetPointEased(_ identifier: TGMapMarkerId, coordinates coordinate: TGGeoPoint, duration: Float, easeType ease: TGEaseType) -> Bool {
    return tgViewController.markerSetPointEased(identifier, coordinates: coordinate, duration: duration, easeType: ease)
  }
  
  open func markerSetPolyline(_ identifier: TGMapMarkerId, polyline: TGGeoPolyline) -> Bool {
    return tgViewController.markerSetPolyline(identifier, polyline: polyline)
  }
  
  open func markerSetPolygon(_ identifier: TGMapMarkerId, polygon: TGGeoPolygon) -> Bool {
    return tgViewController.markerSetPolygon(identifier, polygon: polygon)
  }
  
  open func markerSetVisible(_ identifier: TGMapMarkerId, visible: Bool) -> Bool {
    return tgViewController.markerSetVisible(identifier, visible: visible)
  }
  
  open func markerSetImage(_ identifier: TGMapMarkerId, image: UIImage) -> Bool {
    return tgViewController.markerSetImage(identifier, image: image)
  }
  
  open func markerRemove(_ marker: TGMapMarkerId) -> Bool {
    return tgViewController.markerRemove(marker)
  }
  
  open func loadSceneFile(_ path: String) {
    tgViewController.loadSceneFile(path)
  }
  
  open func loadSceneFile(_ path: String, sceneUpdates: [TGSceneUpdate]) {
    tgViewController.loadSceneFile(path, sceneUpdates: sceneUpdates)
  }

  open func loadSceneFileAsync(_ path: String, onSceneLoaded: OnSceneLoaded?) {
    onSceneLoadedClosure = onSceneLoaded
    tgViewController.loadSceneFileAsync(path)
  }
  
  open func loadSceneFileAsync(_ path: String, sceneUpdates: [TGSceneUpdate], onSceneLoaded: OnSceneLoaded?) {
    onSceneLoadedClosure = onSceneLoaded
    tgViewController.loadSceneFileAsync(path, sceneUpdates: sceneUpdates)
  }
  
  open func queueSceneUpdate(_ componentPath: String, withValue value: String) {
    tgViewController.queueSceneUpdate(componentPath, withValue: value)
  }
  
  open func queue(_ sceneUpdates: [TGSceneUpdate]) {
    tgViewController.queue(sceneUpdates)
  }
  
  open func applySceneUpdates() {
    tgViewController.applySceneUpdates()
  }
  
  open func lngLat(toScreenPosition lngLat: TGGeoPoint) -> CGPoint {
    return tgViewController.lngLat(toScreenPosition: lngLat)
  }
  
  open func screenPosition(toLngLat screenPosition: CGPoint) -> TGGeoPoint {
    return tgViewController.screenPosition(toLngLat: screenPosition)
  }
  
  //! Returns whether or not the map was centered on the device's current location
  open func resetCameraOnCurrentLocation(_ tilt: Float = 0.0, zoomLevel: Float = 16.0, animationDuration: Float = 1.0) -> Bool {
    guard let marker = currentLocationGem else { return false }
    guard let point = lastSetPoint else { return false }
    if marker == 0 { return false } // Invalid Marker
    tgViewController.animate(toZoomLevel: zoomLevel, withDuration: animationDuration)
    tgViewController.animate(toPosition: point, withDuration: animationDuration)
    tgViewController.animate(toTilt: tilt, withDuration: animationDuration)
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
    let _ = showCurrentLocation(enabled)
    showFindMeButon(enabled)
    enabled ? LocationManager.sharedManager.startUpdatingLocation() : LocationManager.sharedManager.stopUpdatingLocation()
    shouldFollowCurrentLocation = enabled
  }

  open func loadScene(_ named: String, apiKey: String? = nil) throws {
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
    tgViewController.markerSetPolyline(marker, polyline: polyLine!)
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
    let _ = resetCameraOnCurrentLocation()
    button.isSelected = !button.isSelected
    shouldFollowCurrentLocation = button.isSelected
  }

  override open func viewDidLoad() {
    super.viewDidLoad()
    LocationManager.sharedManager.delegate = self
    
    self.view.addSubview(tgViewController.view)
    
    tgViewController.gestureDelegate = self
    tgViewController.mapViewDelegate = self
  }

  override open func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    tgViewController.viewWillTransition(to: size, with:coordinator)
  }
    
  override open func viewWillAppear(_ animated: Bool) {
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
      let _ = resetCameraOnCurrentLocation()
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
}

extension MapViewController : TGMapViewDelegate, TGRecognizerDelegate {
  
  //MARK : TGMapViewDelegate
  
  open func mapView(_ mapView: TGMapViewController, didLoadSceneAsync scene: String) {
    onSceneLoadedClosure?(scene)
    onSceneLoadedClosure = nil
  }
  
  open func mapViewDidCompleteLoading(_ mapView: TGMapViewController) {
    tileLoadDelegate?.mapControllerDidCompleteLoading(self)
  }
  
  open func mapView(_ mapView: TGMapViewController, didSelectFeature feature: [AnyHashable : Any]?, atScreenPosition position: CGPoint) {
    guard (feature != nil) else { return }
    featureSelectDelegate?.mapController(self, didSelectFeature: feature, atScreenPosition: position)
  }
  
  open func mapView(_ mapView: TGMapViewController, didSelectLabel labelPickResult: TGLabelPickResult?, atScreenPosition position: CGPoint) {
    guard (labelPickResult != nil) else { return }
    labelSelectDelegate?.mapController(self, didSelectLabel: labelPickResult, atScreenPosition: position)
  }
  
  open func mapView(_ mapView: TGMapViewController, didSelectMarker markerPickResult: TGMarkerPickResult?, atScreenPosition position: CGPoint) {
    guard (markerPickResult != nil) else { return }
    markerSelectDelegate?.mapController(self, didSelectMarker: markerPickResult, atScreenPosition: position)
  }
  
  //MARK : TGRecognizerDelegate
  
  open func mapView(_ view: TGMapViewController, recognizer: UIGestureRecognizer, shouldRecognizeSingleTapGesture location: CGPoint) -> Bool {
    tgViewController.pickLabel(at: location)
    tgViewController.pickMarker(at: location)
    tgViewController.pickFeature(at: location)
    guard let recognize = singleTapGestureDelegate?.mapController(self, recognizer: recognizer, shouldRecognizeSingleTapGesture: location) else { return true }
    return recognize
  }
  
  open func mapView(_ view: TGMapViewController, recognizer: UIGestureRecognizer, didRecognizeSingleTapGesture location: CGPoint) {
    singleTapGestureDelegate?.mapController(self, recognizer: recognizer, didRecognizeSingleTapGesture: location)
  }
  
  open func mapView(_ view: TGMapViewController, recognizer: UIGestureRecognizer, shouldRecognizeDoubleTapGesture location: CGPoint) -> Bool {
    guard let recognize = doubleTapGestureDelegate?.mapController(self, recognizer: recognizer, shouldRecognizeDoubleTapGesture: location)  else { return true }
    return recognize
  }
  
  open func mapView(_ view: TGMapViewController, recognizer: UIGestureRecognizer, didRecognizeDoubleTapGesture location: CGPoint) {
    doubleTapGestureDelegate?.mapController(self, recognizer: recognizer, didRecognizeDoubleTapGesture: location)
  }
  
  open func mapView(_ view: TGMapViewController, recognizer: UIGestureRecognizer, shouldRecognizeLongPressGesture location: CGPoint) -> Bool {
    guard let recognize = longPressGestureDelegate?.mapController(self, recognizer: recognizer, shouldRecognizeLongPressGesture: location) else { return true }
    return recognize
  }
  
  open func mapView(_ view: TGMapViewController, recognizer: UIGestureRecognizer, didRecognizeLongPressGesture location: CGPoint) {
    longPressGestureDelegate?.mapController(self, recognizer: recognizer, didRecognizeLongPressGesture: location)
  }
  
  open func mapView(_ view: TGMapViewController, recognizer: UIGestureRecognizer, shouldRecognizePanGesture displacement: CGPoint) -> Bool {
    if (!panEnabled) {
      shouldFollowCurrentLocation = false
      findMeButton.isSelected = false
    }
    return panEnabled
  }
  
  open func mapView(_ view: TGMapViewController, recognizer: UIGestureRecognizer, didRecognizePanGesture location: CGPoint) {
    shouldFollowCurrentLocation = false
    findMeButton.isSelected = false
    panDelegate?.mapController(self, didPanMap: location)
  }
  
  open func mapView(_ view: TGMapViewController, recognizer: UIGestureRecognizer, shouldRecognizePinchGesture location: CGPoint) -> Bool {
    return pinchEnabled
  }
  
  open func mapView(_ view: TGMapViewController, recognizer: UIGestureRecognizer, didRecognizePinchGesture location: CGPoint) {
    pinchDelegate?.mapController(self, didPinchMap: location)
  }
  
  open func mapView(_ view: TGMapViewController, recognizer: UIGestureRecognizer, shouldRecognizeRotationGesture location: CGPoint) -> Bool {
    return rotateEnabled
  }
  
  open func mapView(_ view: TGMapViewController, recognizer: UIGestureRecognizer, didRecognizeRotationGesture location: CGPoint) {
    rotateDelegate?.mapController(self, didRotateMap: location)
  }
  
  open func mapView(_ view: TGMapViewController, recognizer: UIGestureRecognizer, shouldRecognizeShoveGesture displacement: CGPoint) -> Bool {
    return shoveEnabled
  }
  
  open func mapView(_ view: TGMapViewController, recognizer: UIGestureRecognizer, didRecognizeShoveGesture displacement: CGPoint) {
    shoveDelegate?.mapController(self, didShoveMap: displacement)
  }
}

