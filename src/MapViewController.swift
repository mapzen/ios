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

@objc public enum MZError: Int {
  case GeneralError, AnnotationDoesNotExist, APIKeyNotSet
}

public class MapViewController: TGMapViewController, LocationManagerDelegate, TGRecognizerDelegate {

  //Error Domains for NSError Appeasement
  public static let MapzenGeneralErrorDomain = "MapzenGeneralErrorDomain"


  var currentLocationGem: TGMapMarkerId?
  var lastSetPoint: TGGeoPoint?
  var shouldShowCurrentLocation = false
  public var shouldFollowCurrentLocation = false
  public var findMeButton = UIButton(type: .Custom)
  public var currentAnnotations: [PeliasMapkitAnnotation : TGMapMarkerId] = Dictionary()

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

  //! Returns whether or not the map was centered on the device's current location
  public func resetCameraOnCurrentLocation(tilt: Float = 0.0, zoomLevel: Float = 16.0, animationDuration: Float = 1.0) -> Bool {
    guard let marker = currentLocationGem else { return false }
    guard let point = lastSetPoint else { return false }
    if marker == 0 { return false } // Invalid Marker
    animateToZoomLevel(zoomLevel, withDuration: animationDuration)
    animateToPosition(point, withDuration: animationDuration)
    animateToTilt(tilt, withDuration: animationDuration)
    return true
  }

  //! Handles state for the find me button
  public func showFindMeButon(shouldShow: Bool) {
    findMeButton.hidden = !shouldShow
    findMeButton.enabled = shouldShow
  }

  //! Returns whether or not current location was shown
  public func showCurrentLocation(shouldShow: Bool) -> Bool {
    shouldShowCurrentLocation = shouldShow
    guard let marker = currentLocationGem else {
      let marker = markerAdd()
      if marker == 0 { return false } // Didn't initialize correctly.
      currentLocationGem = marker;
      LocationManager.sharedManager.requestWhenInUseAuthorization()
      markerSetStyling(marker, styling: "{ style: ux-location-gem-overlay, sprite: ux-current-location, size: 36px, collide: false }")
      //Set visibility to false since we have to wait until we have an accurate location
      markerSetVisible(marker, visible: false)
      return true
    }
    markerSetVisible(marker, visible: shouldShowCurrentLocation)
    return true
  }

  public func enableLocationLayer(enabled: Bool) {
    showCurrentLocation(enabled)
    showFindMeButon(enabled)
    enabled ? LocationManager.sharedManager.startUpdatingLocation() : LocationManager.sharedManager.stopUpdatingLocation()
    shouldFollowCurrentLocation = enabled
  }

  public func loadScene(named: String, apiKey: String?) throws {
    loadSceneFile(named)
    if let apiKey = apiKey {
      queueSceneUpdate("sources.mapzen.url_params", withValue: "{ api_key: \(apiKey)}")
    } else {
      if let apiKey = MapzenManager.sharedManager.apiKey {
        queueSceneUpdate("sources.mapzen.url_params", withValue: "{ api_key: \(apiKey)}")

      } else {
        throw NSError(domain: MapViewController.MapzenGeneralErrorDomain,
                      code: MZError.APIKeyNotSet.rawValue,
                      userInfo: nil)
      }
    }
    self.applySceneUpdates()
  }

  public func add(annotations: [PeliasMapkitAnnotation]) throws {
    for annotation in annotations {
      let newMarker = self.markerAdd()
      if newMarker == 0 {
        //TODO: Once TG integrates better error codes, we need to integrate that here.
        // https://github.com/tangrams/tangram-es/issues/1219
        throw NSError(domain: MapViewController.MapzenGeneralErrorDomain,
                      code: MZError.GeneralError.rawValue,
                      userInfo: nil)
      }
      markerSetPoint(newMarker, coordinates: TGGeoPoint(coordinate: annotation.coordinate))
      markerSetStyling(newMarker, styling: "{ style: sdk-point-overlay, sprite: ux-search-active, size: [24, 36px], collide: false }")
      currentAnnotations[annotation] = newMarker

    }
  }

  public func remove(annotation: PeliasMapkitAnnotation) throws {
    guard let markerId = currentAnnotations[annotation] else { return }
    if !markerRemove(markerId) {
      throw NSError(domain: MapViewController.MapzenGeneralErrorDomain,
                    code: MZError.AnnotationDoesNotExist.rawValue,
                    userInfo: nil)
    }
    currentAnnotations.removeValueForKey(annotation)
  }

  public func removeAnnotations() throws {
    for (annotation, markerId) in currentAnnotations {
      if !markerRemove(markerId) {
        throw NSError(domain: MapViewController.MapzenGeneralErrorDomain,
                      code: MZError.AnnotationDoesNotExist.rawValue,
                      userInfo: nil)
      }
      currentAnnotations.removeValueForKey(annotation)
    }
  }

  @objc func defaultFindMeAction(button: UIButton, touchEvent: UIEvent) {
    resetCameraOnCurrentLocation()
    button.selected = !button.selected
    shouldFollowCurrentLocation = button.selected
  }

  override public func viewDidLoad() {
    super.viewDidLoad()
    LocationManager.sharedManager.delegate = self
    gestureDelegate = self
  }

  override public func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    let viewRect = view.bounds
    findMeButton.frame = CGRect(x: viewRect.width - 60.0, y: viewRect.height - 100.0, width: CGFloat(48), height: CGFloat(48))
    view.addSubview(findMeButton)
    findMeButton.sizeToFit()
  }

  func createFindMeButton() -> UIButton {
    let findMeButton = UIButton(type: UIButtonType.Custom)
    findMeButton.addTarget(self, action: #selector(MapViewController.defaultFindMeAction(_:touchEvent:)), forControlEvents: .TouchUpInside)
    findMeButton.enabled = false
    findMeButton.hidden = true
    findMeButton.adjustsImageWhenHighlighted = false
    findMeButton.setBackgroundImage(UIImage(named: "ic_find_me_normal"), forState: .Normal)
    //TODO: This should also have .Highlighted as well .Selected , but something about the @3x assets and UIButton is misbehaving; might need bug opened with Apple.
    findMeButton.setBackgroundImage(UIImage(named: "ic_find_me_pressed"), forState: [.Selected])
    findMeButton.backgroundColor = UIColor.whiteColor()
    findMeButton.autoresizingMask = [.FlexibleTopMargin, .FlexibleLeftMargin]
    return findMeButton
  }

  //MARK: - LocationManagerDelegate

  public func locationDidUpdate(location: CLLocation) {
    guard let marker = currentLocationGem else {
      return
    }
    lastSetPoint = TGGeoPoint(longitude: location.coordinate.longitude, latitude: location.coordinate.latitude)
    markerSetPoint(marker, coordinates: TGGeoPoint(longitude: location.coordinate.longitude, latitude: location.coordinate.latitude))
    if (shouldShowCurrentLocation) {
      markerSetVisible(marker, visible: true)
    }

    if (shouldFollowCurrentLocation) {
      print("Updating for current lat: \(location.coordinate.latitude) & long: \(location.coordinate.longitude)")
      resetCameraOnCurrentLocation()
    }
  }

  public func authorizationDidSucceed() {
    LocationManager.sharedManager.startUpdatingLocation()
    LocationManager.sharedManager.requestLocation()
  }

  public func authorizationDenied() {
    failedLocationAuthorization()
  }

  public func authorizationRestricted() {
    //For our uses, this is effectively the same handling as denied location authorization
    failedLocationAuthorization()
  }

  func failedLocationAuthorization() {
    shouldShowCurrentLocation = false
    guard let marker = currentLocationGem else { return }
    markerRemove(marker)
    return
  }

  //MARK: - TGRecognizerDelegate

  public func mapView(view: TGMapViewController, recognizer: UIGestureRecognizer, didRecognizePanGesture location: CGPoint) {
    shouldFollowCurrentLocation = false
    findMeButton.selected = false
  }
}
