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

/** 
  Mapzen Error Enumeration
  - generalError: The general case for things we're not quite sure what happened.
  - annotationDoesNotExist: The requested annotation does not exist on the map.
  - apiKeyNotSet: Your Mapzen API key is not set. Set this using the `MapzenManager` class.
  - routeDoesNotExist: The requested route does not exist.
 */
@objc public enum MZError: Int {
  case generalError, annotationDoesNotExist, apiKeyNotSet, routeDoesNotExist
}

@objc public enum MapStyle: Int {
  case bubbleWrap, cinnabar, refill, walkabout, zinc
}

/// Single Tap Gesture Delegate
public protocol MapSingleTapGestureDelegate : class {
  /**
   Asks the delegate if the map should recognize this single tap and perform default functionality (which is nothing, currently).

   - parameter controller: The MapViewController that wants to recognize the tap.
   - parameter recognizer: The recognizer that initially recognized the tap.
   - parameter location: The screen coordinates that the tap occured in relative to the bounds of the map.
   
   - returns: Return true for default functionality, or false if don't want it recognized (or plan on handling it yourself).
  */
  func mapController(_ controller: MapViewController, recognizer: UIGestureRecognizer, shouldRecognizeSingleTapGesture location: CGPoint) -> Bool

  /**
   Informs the delegate the map recognized a single tap gesture.

   - parameter controller: The MapViewController that recognized the tap.
   - parameter recognizer: The recognizer that recognized the tap.
   - parameter location: The screen coordinates that the tap occured in relative to the bounds of the map.
   */
  func mapController(_ controller: MapViewController, recognizer: UIGestureRecognizer, didRecognizeSingleTapGesture location: CGPoint)
}

/// Double Tap Gesture Delegate
public protocol MapDoubleTapGestureDelegate : class {
  /**
   Asks the delegate if the map should recognize this double tap and perform default functionality (which is nothing, currently).

   - parameter controller: The MapViewController that wants to recognize the tap.
   - parameter recognizer: The recognizer that initially recognized the tap.
   - parameter location: The screen coordinates that the tap occured in relative to the bounds of the map.

   - returns: Return true for default functionality, or false if don't want it recognized (or plan on handling it yourself).
   */
  func mapController(_ controller: MapViewController, recognizer: UIGestureRecognizer, shouldRecognizeDoubleTapGesture location: CGPoint) -> Bool

  /**
   Informs the delegate the map recognized a double tap gesture.

   - parameter controller: The MapViewController that recognized the tap.
   - parameter recognizer: The recognizer that recognized the tap.
   - parameter location: The screen coordinates that the tap occured in relative to the bounds of the map.
   */
  func mapController(_ controller: MapViewController, recognizer: UIGestureRecognizer, didRecognizeDoubleTapGesture location: CGPoint)
}

/// Long Press Gesture Delegate
public protocol MapLongPressGestureDelegate : class {
  /**
   Asks the delegate if the map should recognize this long press gesture and perform default functionality (which is nothing, currently).

   - parameter controller: The MapViewController that wants to recognize the press.
   - parameter recognizer: The recognizer that initially recognized the press.
   - parameter location: The screen coordinates that the press occured in relative to the bounds of the map.

   - returns: Return true for default functionality, or false if don't want it recognized (or plan on handling it yourself).
   */
  func mapController(_ controller: MapViewController, recognizer: UIGestureRecognizer, shouldRecognizeLongPressGesture location: CGPoint) -> Bool

  /**
   Informs the delegate the map recognized a long press gesture.

   - parameter controller: The MapViewController that recognized the press.
   - parameter recognizer: The recognizer that recognized the press.
   - parameter location: The screen coordinates that the press occured in relative to the bounds of the map.
   */
  func mapController(_ controller: MapViewController, recognizer: UIGestureRecognizer, didRecognizeLongPressGesture location: CGPoint)
}

/// Map Pan Gesture Delegate
public protocol MapPanGestureDelegate : class {
  /**
   Informs the delegate the map just panned.

   - parameter controller: The MapViewController that recognized the pan.
   - parameter displacement: The distance in pixels that the screen was moved by the gesture.
   */
  func mapController(_ controller: MapViewController, didPanMap displacement: CGPoint)
}

/// MapPinchGestureDelegate
public protocol MapPinchGestureDelegate : class {
  /**
   Informs the delegate the map just zoomed via a pinch gesture.

   - parameter controller: The MapViewController that recognized the pinch.
   - parameter location: The screen coordinate the map was pinched at.
   */
  func mapController(_ controller: MapViewController, didPinchMap location: CGPoint)
}

/// MapRotateGestureDelegate
public protocol MapRotateGestureDelegate : class {
  /**
   Informs the delegate the map just rotated.

   - parameter controller: The MapViewController that recognized the rotation.
   - parameter location: The screen coordinate the map was rotated at.
   */
  func mapController(_ controller: MapViewController, didRotateMap location: CGPoint)
}

/// MapShoveGestureDelegate
public protocol MapShoveGestureDelegate : class {
  /**
   Informs the delegate the map just shoved.

   - parameter controller: The MapViewController that recognized the shove.
   - parameter displacement: The distance in pixels that the screen was moved by the gesture.
   */
  func mapController(_ controller: MapViewController, didShoveMap displacement: CGPoint)
}

/// MapFeatureSelectDelegate
public protocol MapFeatureSelectDelegate : class {
  /**
   Informs the delegate a feature of the map was just selected.

   - parameter controller: The MapViewController that recognized the selection.
   - parameter feature: Feature dictionary. The keys available are determined by the provided data in the upstream data source.
   - parameter atScreenPosition: The screen coordinates of the picked feature.
   */
  func mapController(_ controller: MapViewController, didSelectFeature feature: [AnyHashable : Any], atScreenPosition position: CGPoint)
}

/// MapLabelSelectDelegate
public protocol MapLabelSelectDelegate : class {
  /**
   Informs the delegate a label of the map was just selected

   - parameter controller: The MapViewController that recognized the selection.
   - parameter labelPickResult: A label returned as an instance of TGLabelPickResult.
   - parameter atScreenPosition: The screen coordinates of the picked label.
   */
  func mapController(_ controller: MapViewController, didSelectLabel labelPickResult: TGLabelPickResult, atScreenPosition position: CGPoint)
}

/// MapMarkerSelectDelegate
public protocol MapMarkerSelectDelegate : class {
  /**
   Informs the delegate a marker of the map was just selected

   - parameter controller: The MapViewController that recognized the selection.
   - parameter markerPickResult: A marker selection returned as an instance of TGMarkerPickResult.
   - parameter atScreenPosition: The screen coordinates of the picked marker.
   */
  func mapController(_ controller: MapViewController, didSelectMarker markerPickResult: TGMarkerPickResult, atScreenPosition position: CGPoint)
}

/// MapTileLoadDelegate
public protocol MapTileLoadDelegate : class {
  /**
   Informs the delegate the map has completed loading tile data and is displaying the map.

   - parameter controller: The MapViewController that just finished loading.
   */
  func mapControllerDidCompleteLoading(_ controller: MapViewController)
}


/**
 MapViewController is the main class utilized for displaying Mapzen maps on iOS. It aims to provide the full set of features a developer would want for mapping-related tasks, such as displaying routes, results of a search, or the device's current location (and any combination therein.)
 
 MapViewController wraps the underlying `TGMapViewController` from Tangram-es and handles adding it to the view hierarchy. It exposes this in the `tgViewController` property and allows for additional customization there using the Tangram-es iOS framework. Documentation on that is available [here](https://mapzen.com/documentation/tangram/iOS-API/).
 */
open class MapViewController: UIViewController, LocationManagerDelegate {

  //Error Domains for NSError Appeasement
  open static let MapzenGeneralErrorDomain = "MapzenGeneralErrorDomain"
  private static let mapzenRights = "https://mapzen.com/rights/"

  let application : ApplicationProtocol
  open var tgViewController: TGMapViewController = TGMapViewController()
  var currentLocationGem: TGMapMarkerId?
  var lastSetPoint: TGGeoPoint?
  var shouldShowCurrentLocation = false
  var currentRouteMarker: TGMapMarkerId?
  open var shouldFollowCurrentLocation = false
  open var findMeButton = UIButton(type: .custom)
  open var currentAnnotations: [PeliasMapkitAnnotation : TGMapMarkerId] = Dictionary()
  open var attributionBtn = UIButton()

  /// The camera type we want to use. Defaults to whatever is set in the style sheet.
  open var cameraType: TGCameraType {
    set {
      tgViewController.cameraType = cameraType
    }
    get {
      return tgViewController.cameraType
    }
  }

  /// The current position of the map in longitude / latitude.
  open var position: TGGeoPoint {
    set {
      tgViewController.position = position
    }
    get {
      return tgViewController.position
    }
  }

  /// The current zoom level.
  open var zoom: Float {
    set {
      tgViewController.zoom = zoom
    }
    get {
      return tgViewController.zoom
    }
  }

  /// The current rotation, in radians from north.
  open var rotation: Float {
    set {
      tgViewController.rotation = rotation
    }
    get {
      return tgViewController.rotation
    }
  }

  /// The current tilt in radians.
  open var tilt: Float {
    set {
      tgViewController.tilt = tilt
    }
    get {
      return tgViewController.tilt
    }
  }

  /// Enables / Disables panning on the map
  open var panEnabled = true

  /// Enables / Disables pinching on the map
  open var pinchEnabled = true

  /// Enables / Disables rotation on the map
  open var rotateEnabled = true

  /// Enables / Disables shove gestures on the map.
  open var shoveEnabled = true

  /// Receiver for single tap callbacks
  weak open var singleTapGestureDelegate: MapSingleTapGestureDelegate?

  /// Receiver for double tap callbacks
  weak open var doubleTapGestureDelegate: MapDoubleTapGestureDelegate?

  /// Receiver for single tap callbacks
  weak open var longPressGestureDelegate: MapLongPressGestureDelegate?

  /// Receiver for pan gesture callbacks
  weak open var panDelegate: MapPanGestureDelegate?

  /// Receiver for pinch gesture callbacks
  weak open var pinchDelegate: MapPinchGestureDelegate?

  /// Receiver for rotation gesture callbacks
  weak open var rotateDelegate: MapRotateGestureDelegate?

  /// Receiver for shove gesture callbacks
  weak open var shoveDelegate: MapShoveGestureDelegate?

  /// Receiver for feature selection callbacks
  weak open var featureSelectDelegate: MapFeatureSelectDelegate?

  /// Receiver for label selection callbacks
  weak open var labelSelectDelegate: MapLabelSelectDelegate?

  /// Receiver for marker selection callbacks
  weak open var markerSelectDelegate: MapMarkerSelectDelegate?

  /// Receiver for tile load completion callbacks
  weak open var tileLoadDelegate: MapTileLoadDelegate?

  public typealias OnStyleLoaded = (MapStyle) -> ()
  fileprivate var onStyleLoadedClosure : OnStyleLoaded? = nil

  fileprivate let styles = ["bubble-wrap-style-more-labels.yaml" : MapStyle.bubbleWrap,
                            "cinnabar-style-more-labels.yaml" : MapStyle.cinnabar,
                            "refill-style-more-labels.yaml" : MapStyle.refill,
                            "walkabout-style-more-labels.yaml" : MapStyle.walkabout,
                            "zinc-style-more-labels.yaml" : MapStyle.zinc]

  /**
   Default initializer. Sets up the find me button and initializes the TGMapViewController as part of startup.
   
   - returns: A fully formed MapViewController.
  */
  init() {
    application = UIApplication.shared
    super.init(nibName: nil, bundle: nil)
  }

  /**
   Default required initializer for storyboard creation.
   
   - returns: A fully formed MapViewController.
  */
  required public init?(coder aDecoder: NSCoder) {
    application = UIApplication.shared
    super.init(coder: aDecoder)
  }

  /**
   Default required initializer for nib-based creation.

   - returns: A fully formed MapViewController.
   */
  public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    application = UIApplication.shared
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }

  /**
   Initializer that accepts a custom application protocol useful for testing.

   - parameter applicationProtocol: An object conforming to our Application Protocol.
   - returns: A fully formed MapViewController.
   */
  init(applicationProtocol: ApplicationProtocol) {
    application = applicationProtocol
    super.init(nibName: nil, bundle: nil)
  }

  /// Direct access to the underlying TGMapViewController's view.
  open var mapView : GLKView {
    return tgViewController.view as! GLKView
  }

  /// The height of our enclosing tab bar controller's tab bar.
  open var tabBarHeight : CGFloat {
    return self.tabBarController?.tabBar.frame.height ?? 0
  }

  /**
   Animates the map to a particular position using the default easing type (Cubic).
   
   - parameter position: The position to animate to.
   - parameter seconds: How long the animation should last.
  */
  open func animate(toPosition position: TGGeoPoint, withDuration seconds: Float) {
    tgViewController.animate(toPosition: position, withDuration: seconds)
  }

  /**
   Animates the map to a particular position using the provided easing type.
   
   - parameter position: The position to animate to.
   - parameter seconds: How long the animation should last.
   - parameter easeType: The animation easing style to use.
   */
  open func animate(toPosition position: TGGeoPoint, withDuration seconds: Float, with easeType: TGEaseType) {
    tgViewController.animate(toPosition: position, withDuration: seconds, with: easeType)
  }

  /**
   Animates the map to a particular zoom level using the default easing type (Cubic).
   
   - parameter zoomLevel: The zoom level to animate to.
   - parameter seconds: How long the animation should last.
   */
  open func animate(toZoomLevel zoomLevel: Float, withDuration seconds: Float) {
    tgViewController.animate(toZoomLevel: zoomLevel, withDuration: seconds)
  }

  /**
   Animates the map to a particular zoom level using the provided easing type.
   
   - parameter zoomLevel: The zoom level to animate to.
   - parameter seconds: How long the animation should last.
   - parameter easeType: The animation easing style to use.
   */
  open func animate(toZoomLevel zoomLevel: Float, withDuration seconds: Float, with easeType: TGEaseType) {
    tgViewController.animate(toZoomLevel: zoomLevel, withDuration: seconds, with: easeType)
  }

  /**
   Animates the map to rotate using the default easing type (Cubic).
   
   - parameter radians: How far the map should rotate in radians.
   - parameter seconds: How long the animation should last.
   */
  open func animate(toRotation radians: Float, withDuration seconds: Float) {
    tgViewController.animate(toRotation: radians, withDuration: seconds)
  }

  /**
   Animates the map to rotate using the provided easing type.
   
   - parameter radians: How far the map should rotate in radians.
   - parameter seconds: How long the animation should last.
   - parameter easeType: The animation easing style to use.
   */
  open func animate(toRotation radians: Float, withDuration seconds: Float, with easeType: TGEaseType) {
    tgViewController.animate(toRotation: radians, withDuration: seconds, with: easeType)
  }
  
  /**
   Animates the map to tilt using the default easing type (Cubic).
   
   - parameter radians: How far the map should tilt in radians.
   - parameter seconds: How long the animation should last.
   */
  open func animate(toTilt radians: Float, withDuration seconds: Float) {
    tgViewController.animate(toTilt: radians, withDuration: seconds)
  }

  /**
   Animates the map to tile using the provided easing type.
   
   - parameter radians: How far the map should tilt in radians.
   - parameter seconds: How long the animation should last.
   - parameter easeType: The animation easing style to use.
   */
  open func animate(toTilt radians: Float, withDuration seconds: Float, with easeType: TGEaseType) {
    tgViewController.animate(toTilt: radians, withDuration: seconds, with: easeType)
  }

  /// Removes all existing markers on the map.
  open func markerRemoveAll() {
    tgViewController.markerRemoveAll()
  }

  /** 
   Adds an individual marker to the map.
   
   - returns: A marker id from Tangram.
   */
  open func markerAdd() -> TGMapMarkerId {
    return tgViewController.markerAdd()
  }

  /**
   Sets the styling of a particular marker.
   
   - parameter identifier: The marker to style.
   - parameter styling: The styling string to use.
   - returns: A boolean that represents if the style update succeeded.
  */
  open func markerSetStyling(_ identifier: TGMapMarkerId, styling: String) -> Bool {
    return tgViewController.markerSetStyling(identifier, styling: styling)
  }

  /**
   Sets the marker location on the map.
   
   - parameter identifier: The marker to locate on the map.
   - parameter coordinate: The lat/long to put the marker at.
   - returns: A boolean if the location set succeeded.
  */
  open func markerSetPoint(_ identifier: TGMapMarkerId, coordinates coordinate: TGGeoPoint) -> Bool {
    return tgViewController.markerSetPoint(identifier, coordinates: coordinate)
  }

  /**
   Sets the marker location on the map in an animated fashion using the provided easing type
   
   - parameter identifier: The marker to locate on the map.
   - parameter coordinate: The lat/long to put the marker at.
   - parameter duration: How long the animation should last.
   - parameter easeType: The animation easing style to use.
   - returns: A boolean if the location set succeeded.
   */
  open func markerSetPointEased(_ identifier: TGMapMarkerId, coordinates coordinate: TGGeoPoint, duration: Float, easeType ease: TGEaseType) -> Bool {
    return tgViewController.markerSetPointEased(identifier, coordinates: coordinate, seconds: duration, easeType: ease)
  }

  /**
   Sets the marker to represent a particular polyline.
   
   - parameter identifier: The marker to set.
   - pameter polyline: The polyline to represent the marker.
   - returns: A boolean if the marker set succeeded.
   */
  open func markerSetPolyline(_ identifier: TGMapMarkerId, polyline: TGGeoPolyline) -> Bool {
    return tgViewController.markerSetPolyline(identifier, polyline: polyline)
  }

  /**
   Sets the marker to represent a particular polygon.
   
   - parameter identifier: The marker to set.
   - pameter polygon: The polygon to represent the marker.
   - returns: A boolean if the marker set succeeded.
   */
  open func markerSetPolygon(_ identifier: TGMapMarkerId, polygon: TGGeoPolygon) -> Bool {
    return tgViewController.markerSetPolygon(identifier, polygon: polygon)
  }

  /**
   Sets the marker if it should be visible or not.
   
   - parameter identifier: The marker to alter visibility on.
   - parameter visible: True means visible. False mean not visible.
   - returns: A boolean indiciation whether or not the update succeeded.
  */
  open func markerSetVisible(_ identifier: TGMapMarkerId, visible: Bool) -> Bool {
    return tgViewController.markerSetVisible(identifier, visible: visible)
  }

  /**
   Sets the marker bitmap image.
   
   - parameter identifier: The marker to set the image for.
   - parameter image: A UIImage to represent the marker.
   - returns: A boolean indiciation whether or not the update succeeded.
   */
  open func markerSetImage(_ identifier: TGMapMarkerId, image: UIImage) -> Bool {
    return tgViewController.markerSetImage(identifier, image: image)
  }

  /**
   Removes an individual marker from the map.
   
   - parameter marker: The marker to remove.
   - returns: A boolean indicating if the removal succeeded.
  */
  open func markerRemove(_ marker: TGMapMarkerId) -> Bool {
    return tgViewController.markerRemove(marker)
  }

  /** 
   Loads a map style synchronously on the main thread. Use the async methods instead of these in production apps.
   
   - parameter style: The map style to load.
   - throws: A MZError `apiKeyNotSet` error if an API Key has not been sent on the MapzenManager class.
 */
  open func loadStyle(_ style: MapStyle) throws {
    try loadStyle(style, sceneUpdates: [TGSceneUpdate]())
  }

  /**
   Loads a map style synchronously on the main thread. Use the async methods instead of these in production apps.
   
   - parameter style: The map style to load.
   - parameter sceneUpdates: The scene updates to make while loading the map style.
   - throws: A MZError `apiKeyNotSet` error if an API Key has not been sent on the MapzenManager class.
  */
  open func loadStyle(_ style: MapStyle, sceneUpdates: [TGSceneUpdate]) throws {
    guard let sceneFile = styles.keyForValue(value: style) else { return }
    try tgViewController.loadSceneFile(sceneFile, sceneUpdates: updatesWithApiKeyUpdate(sceneUpdates))
  }

  /**
   Loads the map style asynchronously. Recommended for production apps. If you have scene updates to apply, either use the other version of this method that allows you to pass in scene updates during load, or wait until onSceneLoaded is called to apply those updates.
   
   - parameter style: The map style to load.
   - parameter onSceneLoaded: Closure called on scene loaded.
   - throws: A MZError `apiKeyNotSet` error if an API Key has not been sent on the MapzenManager class.
  */
  open func loadStyleAsync(_ style: MapStyle, onStyleLoaded: OnStyleLoaded?) throws {
    try loadStyleAsync(style, sceneUpdates: [TGSceneUpdate](), onStyleLoaded: onStyleLoaded)
  }

  /**
   Loads the map style asynchronously. Recommended for production apps. If you have scene updates to apply, either pass in the scene updates at the initial call, or wait until onSceneLoaded is called to apply those updates.
   
   - parameter style: The map style to load.
   - parameter sceneUpdates: The scene updates to make while loading the map style.
   - parameter onSceneLoaded: Closure called on scene loaded.
   - throws: A MZError `apiKeyNotSet` error if an API Key has not been sent on the MapzenManager class.
   */
  open func loadStyleAsync(_ style: MapStyle, sceneUpdates: [TGSceneUpdate], onStyleLoaded: OnStyleLoaded?) throws {
    onStyleLoadedClosure = onStyleLoaded
    guard let sceneFile = styles.keyForValue(value: style) else { return }
    try tgViewController.loadSceneFileAsync(sceneFile, sceneUpdates: updatesWithApiKeyUpdate(sceneUpdates))
  }

  /**
   Queue a scene update using a yaml string path. It's recommended to use the other version of this that uses the TGSceneUpdate objects. Try to queue as many scene updates as you can in one pass as each `applySceneUpdates()` call can require a re-parse of the yaml and a re-render of the map. It is required to call `applySceneUpdates()` to activate the updated that have been enqueued.
   
   - parameter componentPath: The yaml path to the component to change.
   - parameter value: The value to update the component to.
  */
  open func queueSceneUpdate(_ componentPath: String, withValue value: String) {
    tgViewController.queueSceneUpdate(componentPath, withValue: value)
  }

  /**
   Queue an array of scene updates. Try to queue as many scene updates as you can in one pass as each `applySceneUpdates()` call can require a re-parse of the yaml and a re-render of the map. It is required to call `applySceneUpdates()` to activate the updated that have been enqueued.
   
   - parameter sceneUpdates: An array of TGSceneUpdate objects to update the map.
  */
  open func queue(_ sceneUpdates: [TGSceneUpdate]) {
    tgViewController.queue(sceneUpdates)
  }

  //Applies all queued scene updates.
  open func applySceneUpdates() {
    tgViewController.applySceneUpdates()
  }

  /**
   Convenience function that converts TGGeoPoints to UIKit screen coordinates.
   
   - parameter lngLat: TGGeoPoint to convert
   - returns: The CGPoint in screen space.
  */
  open func lngLat(toScreenPosition lngLat: TGGeoPoint) -> CGPoint {
    return tgViewController.lngLat(toScreenPosition: lngLat)
  }

  /**
   Convenience function that converts UIKit screen coordinates to a lat/long pair.
   
   - parameter screenPosition: The screen coordinate to convert.
   - returns: A TGGeoPoint in lat/long for the screen coordinate.
  */
  open func screenPosition(toLngLat screenPosition: CGPoint) -> TGGeoPoint {
    return tgViewController.screenPosition(toLngLat: screenPosition)
  }
  
  /**
   Resets the camera on the current location, as well as the zoom and tilt.
   
   - parameter tilt: The tilt to reset to. Defaults to 0.
   - parameter zoomLevel: The zoom to reset to. Defaults to 0.
   - parameter animationDuration: The length to animate the reset to. Passing in 0 makes the change happen immediately.
   - returns: Whether or not the map was centered on the device's current location
   */
  open func resetCameraOnCurrentLocation(_ tilt: Float = 0.0, zoomLevel: Float = 16.0, animationDuration: Float = 1.0) -> Bool {
    guard let marker = currentLocationGem else { return false }
    guard let point = lastSetPoint else { return false }
    if marker == 0 { return false } // Invalid Marker
    tgViewController.animate(toZoomLevel: zoomLevel, withDuration: animationDuration)
    tgViewController.animate(toPosition: point, withDuration: animationDuration)
    tgViewController.animate(toTilt: tilt, withDuration: animationDuration)
    return true
  }

  /** 
   Handles state for the find me button.
   
   - parameter shouldShow: Shows or hides the button
   */
  open func showFindMeButon(_ shouldShow: Bool) {
    findMeButton.isHidden = !shouldShow
    findMeButton.isEnabled = shouldShow
  }

  /**
   Shows or hides the current location of the device. This starts the location request process and will prompt the user the first time its called.
   
   - parameter shouldShow: Whether or not we should show the current location.
   - returns: Whether or not current location was shown
   */
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

  /** 
   Enables / Disables the entire current location layer.
    
   - parameter enabled: True if we should enable the location layer. False disables it.
   */
  open func enableLocationLayer(_ enabled: Bool) {
    let _ = showCurrentLocation(enabled)
    showFindMeButon(enabled)
    enabled ? LocationManager.sharedManager.startUpdatingLocation() : LocationManager.sharedManager.stopUpdatingLocation()
    shouldFollowCurrentLocation = enabled
  }


  /** 
   Adds an array of annotations to the map.
   
   - parameter annotations: An array of annotations to add.
   - throws: A MZError `generalError` if the underlying map fails to add any of the annotations.
   */
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
      tgViewController.markerSetStyling(newMarker, styling: "{ style: sdk-point-overlay, sprite: ux-search-active, size: [24, 36px], collide: false, interactive: true }")
      currentAnnotations[annotation] = newMarker
    }
  }

  /** 
   Removes a single annotation
   
   - parameter annotation: The annotation to remove
   - throws: A MZError `annotationDoesNotExist` error.
   */
  open func remove(_ annotation: PeliasMapkitAnnotation) throws {
    guard let markerId = currentAnnotations[annotation] else { return }
    if !tgViewController.markerRemove(markerId) {
      throw NSError(domain: MapViewController.MapzenGeneralErrorDomain,
                    code: MZError.annotationDoesNotExist.rawValue,
                    userInfo: nil)
    }
    currentAnnotations.removeValue(forKey: annotation)
  }

  /** 
   Removes all currents annotations.

   - throws: A MZError `annotationDoesNotExist` error if it encounters an annotation that no longer exists.
   */
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

  /** 
   Displays a routing result on the map. This currently only supports single start and endpoint routes. If there's an existing route it will be silently replaced.
   
   - parameter route: The route to display.
   - throws: A MZError `generalError` if the map can't add the route.
   */
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
      polyLine.add(TGGeoPoint(coordinate: point!))
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

  /**
   Removes the route from the map
   
   - throws: A MZError `routeDoesNotExist` error if there isn't a current route or the map can't find one to remove.
   */
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

    setupTgControllerView()
    setupAttribution()
    setupFindMeButton()

    tgViewController.gestureDelegate = self
    tgViewController.mapViewDelegate = self
  }

  override open func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    let adjustedSize = CGSize(width: size.width, height: size.height-tabBarHeight)
    tgViewController.viewWillTransition(to: adjustedSize, with:coordinator)
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

  //MARK: - private

  private func setupTgControllerView() {
    tgViewController.view.translatesAutoresizingMaskIntoConstraints = false
    self.view.addSubview(tgViewController.view)

    let leftConstraint = tgViewController.view.leftAnchor.constraint(equalTo: view.leftAnchor)
    let rightConstraint = tgViewController.view.rightAnchor.constraint(equalTo: view.rightAnchor)
    let topConstraint = tgViewController.view.topAnchor.constraint(equalTo: view.topAnchor)
    let bottomConstraint = tgViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -tabBarHeight)
    NSLayoutConstraint.activate([leftConstraint, rightConstraint, topConstraint, bottomConstraint])
  }

  private func setupAttribution() {
    attributionBtn = UIButton()
    attributionBtn.setTitle("Powered by Mapzen", for: .normal)
    attributionBtn.setTitleColor(.darkGray, for: .normal)
    attributionBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
    attributionBtn.addTarget(self, action: #selector(openMapzenTerms), for: .touchUpInside)
    attributionBtn.sizeToFit()
    attributionBtn.translatesAutoresizingMaskIntoConstraints = false
    mapView.addSubview(attributionBtn)

    let horizontalConstraint = attributionBtn.leftAnchor.constraint(equalTo: mapView.leftAnchor, constant: Dimensions.defaultPadding)
    let verticalConstraint = attributionBtn.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -Dimensions.defaultPadding)
    NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint])
  }

  func setupFindMeButton() {
    findMeButton = UIButton(type: UIButtonType.custom)
    findMeButton.addTarget(self, action: #selector(MapViewController.defaultFindMeAction(_:touchEvent:)), for: .touchUpInside)
    findMeButton.isEnabled = false
    findMeButton.isHidden = true
    findMeButton.adjustsImageWhenHighlighted = false
    findMeButton.setBackgroundImage(UIImage(named: "ic_find_me_normal"), for: UIControlState())
    //TODO: This should also have .Highlighted as well .Selected , but something about the @3x assets and UIButton is misbehaving; might need bug opened with Apple.
    findMeButton.setBackgroundImage(UIImage(named: "ic_find_me_pressed"), for: [.selected])
    findMeButton.backgroundColor = UIColor.white
    //findMeButton.autoresizingMask = [.flexibleTopMargin, .flexibleLeftMargin]
    findMeButton.translatesAutoresizingMaskIntoConstraints = false
    mapView.addSubview(findMeButton)

    let horizontalConstraint = findMeButton.rightAnchor.constraint(equalTo: mapView.rightAnchor, constant: -Dimensions.defaultPadding)
    let verticalConstraint = findMeButton.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -Dimensions.defaultPadding)
    let widthConstraint = findMeButton.widthAnchor.constraint(equalToConstant: Dimensions.squareMapBtnSize)
    let heightConstraint = findMeButton.widthAnchor.constraint(equalToConstant: Dimensions.squareMapBtnSize)
    NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
  }

  @objc private func openMapzenTerms() {
    guard let url = URL(string: MapViewController.mapzenRights) else { return }
    let _ = application.openURL(url)
  }

  private func updatesWithApiKeyUpdate(_ sceneUpdates: [TGSceneUpdate]) throws -> [TGSceneUpdate] {
    guard let apiKey = MapzenManager.sharedManager.apiKey else {
      throw NSError(domain: MapViewController.MapzenGeneralErrorDomain,
                    code: MZError.apiKeyNotSet.rawValue,
                    userInfo: nil)
    }
    var allSceneUpdates = [TGSceneUpdate]()
    allSceneUpdates.append(contentsOf: sceneUpdates)
    allSceneUpdates.append(TGSceneUpdate(path: "global.sdk_mapzen_api_key", value: "'\(apiKey)'"))
    return allSceneUpdates
  }
}

extension MapViewController : TGMapViewDelegate, TGRecognizerDelegate {
  
  //MARK : TGMapViewDelegate
  
  open func mapView(_ mapView: TGMapViewController, didLoadSceneAsync scene: String) {
    guard let style = styles[scene] else {
      onStyleLoadedClosure = nil
      return
    }
    onStyleLoadedClosure?(style)
    onStyleLoadedClosure = nil
  }
  
  open func mapViewDidCompleteLoading(_ mapView: TGMapViewController) {
    tileLoadDelegate?.mapControllerDidCompleteLoading(self)
  }
  
  open func mapView(_ mapView: TGMapViewController, didSelectFeature feature: [AnyHashable : Any]?, atScreenPosition position: CGPoint) {
    guard let feature = feature else { return }
    featureSelectDelegate?.mapController(self, didSelectFeature: feature, atScreenPosition: position)
  }
  
  open func mapView(_ mapView: TGMapViewController, didSelectLabel labelPickResult: TGLabelPickResult?, atScreenPosition position: CGPoint) {
    guard let labelPickResult = labelPickResult else { return }
    labelSelectDelegate?.mapController(self, didSelectLabel: labelPickResult, atScreenPosition: position)
  }
  
  open func mapView(_ mapView: TGMapViewController, didSelectMarker markerPickResult: TGMarkerPickResult?, atScreenPosition position: CGPoint) {
    guard let markerPickResult = markerPickResult else { return }
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

