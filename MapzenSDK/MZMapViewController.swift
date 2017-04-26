//
//  MZMapViewController.swift
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

struct StateReclaimer {
  public let tilt: Float
  public let rotation: Float
  public let zoom: Float
  public let position: TGGeoPoint
  public let cameraType: TGCameraType
  public let mapStyle: MapStyle
}

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

   - parameter controller: The MZMapViewController that wants to recognize the tap.
   - parameter recognizer: The recognizer that initially recognized the tap.
   - parameter location: The screen coordinates that the tap occured in relative to the bounds of the map.
   
   - returns: Return true for default functionality, or false if don't want it recognized (or plan on handling it yourself).
  */
  func mapController(_ controller: MZMapViewController, recognizer: UIGestureRecognizer, shouldRecognizeSingleTapGesture location: CGPoint) -> Bool

  /**
   Informs the delegate the map recognized a single tap gesture.

   - parameter controller: The MZMapViewController that recognized the tap.
   - parameter recognizer: The recognizer that recognized the tap.
   - parameter location: The screen coordinates that the tap occured in relative to the bounds of the map.
   */
  func mapController(_ controller: MZMapViewController, recognizer: UIGestureRecognizer, didRecognizeSingleTapGesture location: CGPoint)
}

/// Double Tap Gesture Delegate
public protocol MapDoubleTapGestureDelegate : class {
  /**
   Asks the delegate if the map should recognize this double tap and perform default functionality (which is nothing, currently).

   - parameter controller: The MZMapViewController that wants to recognize the tap.
   - parameter recognizer: The recognizer that initially recognized the tap.
   - parameter location: The screen coordinates that the tap occured in relative to the bounds of the map.

   - returns: Return true for default functionality, or false if don't want it recognized (or plan on handling it yourself).
   */
  func mapController(_ controller: MZMapViewController, recognizer: UIGestureRecognizer, shouldRecognizeDoubleTapGesture location: CGPoint) -> Bool

  /**
   Informs the delegate the map recognized a double tap gesture.

   - parameter controller: The MZMapViewController that recognized the tap.
   - parameter recognizer: The recognizer that recognized the tap.
   - parameter location: The screen coordinates that the tap occured in relative to the bounds of the map.
   */
  func mapController(_ controller: MZMapViewController, recognizer: UIGestureRecognizer, didRecognizeDoubleTapGesture location: CGPoint)
}

/// Long Press Gesture Delegate
public protocol MapLongPressGestureDelegate : class {
  /**
   Asks the delegate if the map should recognize this long press gesture and perform default functionality (which is nothing, currently).

   - parameter controller: The MZMapViewController that wants to recognize the press.
   - parameter recognizer: The recognizer that initially recognized the press.
   - parameter location: The screen coordinates that the press occured in relative to the bounds of the map.

   - returns: Return true for default functionality, or false if don't want it recognized (or plan on handling it yourself).
   */
  func mapController(_ controller: MZMapViewController, recognizer: UIGestureRecognizer, shouldRecognizeLongPressGesture location: CGPoint) -> Bool

  /**
   Informs the delegate the map recognized a long press gesture.

   - parameter controller: The MZMapViewController that recognized the press.
   - parameter recognizer: The recognizer that recognized the press.
   - parameter location: The screen coordinates that the press occured in relative to the bounds of the map.
   */
  func mapController(_ controller: MZMapViewController, recognizer: UIGestureRecognizer, didRecognizeLongPressGesture location: CGPoint)
}

/// Map Pan Gesture Delegate
public protocol MapPanGestureDelegate : class {
  /**
   Informs the delegate the map just panned.

   - parameter controller: The MZMapViewController that recognized the pan.
   - parameter displacement: The distance in pixels that the screen was moved by the gesture.
   */
  func mapController(_ controller: MZMapViewController, didPanMap displacement: CGPoint)
}

/// MapPinchGestureDelegate
public protocol MapPinchGestureDelegate : class {
  /**
   Informs the delegate the map just zoomed via a pinch gesture.

   - parameter controller: The MZMapViewController that recognized the pinch.
   - parameter location: The screen coordinate the map was pinched at.
   */
  func mapController(_ controller: MZMapViewController, didPinchMap location: CGPoint)
}

/// MapRotateGestureDelegate
public protocol MapRotateGestureDelegate : class {
  /**
   Informs the delegate the map just rotated.

   - parameter controller: The MZMapViewController that recognized the rotation.
   - parameter location: The screen coordinate the map was rotated at.
   */
  func mapController(_ controller: MZMapViewController, didRotateMap location: CGPoint)
}

/// MapShoveGestureDelegate
public protocol MapShoveGestureDelegate : class {
  /**
   Informs the delegate the map just shoved.

   - parameter controller: The MZMapViewController that recognized the shove.
   - parameter displacement: The distance in pixels that the screen was moved by the gesture.
   */
  func mapController(_ controller: MZMapViewController, didShoveMap displacement: CGPoint)
}

/// MapFeatureSelectDelegate
public protocol MapFeatureSelectDelegate : class {
  /**
   Informs the delegate a feature of the map was just selected.

   - parameter controller: The MZMapViewController that recognized the selection.
   - parameter feature: Feature dictionary. The keys available are determined by the provided data in the upstream data source.
   - parameter atScreenPosition: The screen coordinates of the picked feature.
   */
  func mapController(_ controller: MZMapViewController, didSelectFeature feature: [String : String], atScreenPosition position: CGPoint)
}

/// MapLabelSelectDelegate
public protocol MapLabelSelectDelegate : class {
  /**
   Informs the delegate a label of the map was just selected

   - parameter controller: The MZMapViewController that recognized the selection.
   - parameter labelPickResult: A label returned as an instance of TGLabelPickResult.
   - parameter atScreenPosition: The screen coordinates of the picked label.
   */
  func mapController(_ controller: MZMapViewController, didSelectLabel labelPickResult: TGLabelPickResult, atScreenPosition position: CGPoint)
}

/// MapMarkerSelectDelegate
public protocol MapMarkerSelectDelegate : class {
  /**
   Informs the delegate a marker of the map was just selected

   - parameter controller: The MZMapViewController that recognized the selection.
   - parameter markerPickResult: A marker selection returned as an instance conforming to GenericMarker.
   - parameter atScreenPosition: The screen coordinates of the picked marker.
   */
  func mapController(_ controller: MZMapViewController, didSelectMarker marker: GenericMarker, atScreenPosition position: CGPoint)
}

/// MapTileLoadDelegate
public protocol MapTileLoadDelegate : class {
  /**
   Informs the delegate the map has completed loading tile data and is displaying the map.

   - parameter controller: The MZMapViewController that just finished loading.
   */
  func mapControllerDidCompleteLoading(_ controller: MZMapViewController)
}


/**
 MZMapViewController is the main class utilized for displaying Mapzen maps on iOS. It aims to provide the full set of features a developer would want for mapping-related tasks, such as displaying routes, results of a search, or the device's current location (and any combination therein.)
 
 MZMapViewController wraps the underlying `TGMapViewController` from Tangram-es and handles adding it to the view hierarchy. It exposes this in the `tgViewController` property and allows for additional customization there using the Tangram-es iOS framework. Documentation on that is available [here](https://mapzen.com/documentation/tangram/iOS-API/).
 */
open class MZMapViewController: UIViewController, LocationManagerDelegate {

  //Error Domains for NSError Appeasement
  open static let MapzenGeneralErrorDomain = "MapzenGeneralErrorDomain"
  private static let mapzenRights = "https://mapzen.com/rights/"
  private static let kGlobalPathApiKey = "global.sdk_mapzen_api_key"
  private static let kGlobalPathLanguage = "global.ux_language"

  private var isCurrentlyVisible = false // We can't rely on things like window being non-nil because page controllers have a non-nil window as they're being rendered off screen

  let application : ApplicationProtocol
  open var tgViewController: TGMapViewController = TGMapViewController()
  var currentLocationGem: GenericSystemPointMarker?
  var lastSetPoint: TGGeoPoint?
  var shouldShowCurrentLocation = false
  var currentRouteMarker: GenericMarker?
  var currentRoute: OTRRoutingResult?
  open var shouldFollowCurrentLocation = false
  open var findMeButton = UIButton(type: .custom)
  var currentAnnotations: [PeliasMapkitAnnotation : TGMarker] = Dictionary()
  var currentMarkers: [TGMarker : GenericMarker] = Dictionary()
  open var attributionBtn = UIButton()
  private var locale = Locale.current
  var stateSaver: StateReclaimer?
  var currentStyle: MapStyle = .bubbleWrap

  /// The camera type we want to use. Defaults to whatever is set in the style sheet.
  open var cameraType: TGCameraType {
    set {
      tgViewController.cameraType = newValue
    }
    get {
      return tgViewController.cameraType
    }
  }

  /// The current position of the map in longitude / latitude.
  open var position: TGGeoPoint {
    set {
      tgViewController.position = newValue
    }
    get {
      return tgViewController.position
    }
  }

  /// The current zoom level.
  open var zoom: Float {
    set {
      tgViewController.zoom = newValue
    }
    get {
      return tgViewController.zoom
    }
  }

  /// The current rotation, in radians from north.
  open var rotation: Float {
    set {
      tgViewController.rotation = newValue
    }
    get {
      return tgViewController.rotation
    }
  }

  /// The current tilt in radians.
  open var tilt: Float {
    set {
      tgViewController.tilt = newValue
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

  fileprivate let styles = ["bubble-wrap/bubble-wrap-style-more-labels" : MapStyle.bubbleWrap,
                            "cinnabar/cinnabar-style-more-labels" : MapStyle.cinnabar,
                            "refill/refill-style-more-labels" : MapStyle.refill,
                            "walkabout/walkabout-style-more-labels" : MapStyle.walkabout,
                            "zinc/zinc-style-more-labels" : MapStyle.zinc]

  let locationManager : LocationManagerProtocol
  let mapzenManager : MapzenManagerProtocol

  /**
   Default initializer. Sets up the find me button and initializes the TGMapViewController as part of startup.
   
   - returns: A fully formed MZMapViewController.
  */
  public init() {
    application = UIApplication.shared
    locationManager = LocationManager()
    mapzenManager = MapzenManager.sharedManager
    super.init(nibName: nil, bundle: nil)
  }

  /**
   Default required initializer for storyboard creation.
   
   - returns: A fully formed MZMapViewController.
  */
  required public init?(coder aDecoder: NSCoder) {
    application = UIApplication.shared
    locationManager = LocationManager()
    mapzenManager = MapzenManager.sharedManager
    super.init(coder: aDecoder)
  }

  /**
   Default required initializer for nib-based creation.

   - returns: A fully formed MZMapViewController.
   */
  public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    application = UIApplication.shared
    locationManager = LocationManager()
    mapzenManager = MapzenManager.sharedManager
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }

  /**
   Initializer that accepts a custom application protocol and a location manager protocol useful for testing.

   - parameter applicationProtocol: An object conforming to our Application Protocol.
   - parameter locationManager: An object conforming to our LocationManagerProtocol.
   - parameter mapzenManagerProtocol: An object conforming to our MapzenManagerProtocol.
   - returns: A fully formed MZMapViewController.
   */
  init(applicationProtocol: ApplicationProtocol, locationManagerProtocol: LocationManagerProtocol, mapzenManagerProtocol: MapzenManagerProtocol) {
    application = applicationProtocol
    locationManager = locationManagerProtocol
    mapzenManager = mapzenManagerProtocol
    super.init(nibName: nil, bundle: nil)
  }

  /// Direct access to the underlying TGMapViewController's view.
  open var mapView : GLKView {
    return tgViewController.view as! GLKView
  }

  /// The height of our enclosing tab bar controller's tab bar if it is translucent.
  open var tabBarOffset : CGFloat {
    guard let tabBar = self.tabBarController?.tabBar else { return 0 }
    return tabBar.isTranslucent ? tabBar.frame.height : 0
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

  /**
   Adds a marker to the map. A marker can only be added to one map at a time.
   
   - parameter marker: The marker to add to map.
   */
  open func addMarker(_ marker: GenericMarker) {
    currentMarkers[marker.tgMarker] = marker
    marker.tgMarker.map = tgViewController
  }

  /**
   Removes a marker from the map.

   - parameter marker: The marker to remove from map.
   */
  open func removeMarker(_ marker: GenericMarker) {
    currentMarkers.removeValue(forKey: marker.tgMarker)
    marker.tgMarker.map = nil
  }

  /// Removes all existing markers on the map.
  open func markerRemoveAll() {
    tgViewController.markerRemoveAll()
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
   - parameter locale: The locale to use for the map's language.
   - throws: A MZError `apiKeyNotSet` error if an API Key has not been sent on the MapzenManager class.
   */
  open func loadStyle(_ style: MapStyle, locale: Locale) throws {
    try loadStyle(style, locale: locale, sceneUpdates: [TGSceneUpdate]())
  }

  /**
   Loads a map style synchronously on the main thread. Use the async methods instead of these in production apps.
   
   - parameter style: The map style to load.
   - parameter sceneUpdates: The scene updates to make while loading the map style.
   - throws: A MZError `apiKeyNotSet` error if an API Key has not been sent on the MapzenManager class.
  */
  open func loadStyle(_ style: MapStyle, sceneUpdates: [TGSceneUpdate]) throws {
    try loadStyle(style, locale: Locale.current, sceneUpdates: sceneUpdates)
  }

  /**
   Loads a map style synchronously on the main thread. Use the async methods instead of these in production apps.

   - parameter style: The map style to load.
   - parameter locale: The locale to use for the map's language.
   - parameter sceneUpdates: The scene updates to make while loading the map style.
   - throws: A MZError `apiKeyNotSet` error if an API Key has not been sent on the MapzenManager class.
   */
  open func loadStyle(_ style: MapStyle, locale l: Locale, sceneUpdates: [TGSceneUpdate]) throws {
    locale = l
    guard let sceneFile = styles.keyForValue(value: style) else { return }
    currentStyle = style
    guard let qualifiedSceneFile = Bundle.houseStylesBundle()?.url(forResource: sceneFile, withExtension: "yaml")?.absoluteString else {
      return
    }
    try tgViewController.loadSceneFile(qualifiedSceneFile, sceneUpdates: allSceneUpdates(sceneUpdates))
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
   Loads the map style asynchronously. Recommended for production apps. If you have scene updates to apply, either use the other version of this method that allows you to pass in scene updates during load, or wait until onSceneLoaded is called to apply those updates.

   - parameter style: The map style to load.
   - parameter locale: The locale to use for the map's language.
   - parameter onSceneLoaded: Closure called on scene loaded.
   - throws: A MZError `apiKeyNotSet` error if an API Key has not been sent on the MapzenManager class.
   */
  open func loadStyleAsync(_ style: MapStyle, locale: Locale, onStyleLoaded: OnStyleLoaded?) throws {
    try loadStyleAsync(style, locale: locale, sceneUpdates: [], onStyleLoaded: onStyleLoaded)
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
    currentStyle = style
    guard let qualifiedSceneFile = Bundle.houseStylesBundle()?.url(forResource: sceneFile, withExtension: "yaml")?.absoluteString else {
      return
    }
    try tgViewController.loadSceneFileAsync(qualifiedSceneFile, sceneUpdates: allSceneUpdates(sceneUpdates))
  }

  /**
   Loads the map style asynchronously. Recommended for production apps. If you have scene updates to apply, either pass in the scene updates at the initial call, or wait until onSceneLoaded is called to apply those updates.

   - parameter style: The map style to load.
   - parameter locale: The locale to use for the map's language.
   - parameter sceneUpdates: The scene updates to make while loading the map style.
   - parameter onSceneLoaded: Closure called on scene loaded.
   - throws: A MZError `apiKeyNotSet` error if an API Key has not been sent on the MapzenManager class.
   */
  open func loadStyleAsync(_ style: MapStyle, locale l: Locale, sceneUpdates: [TGSceneUpdate], onStyleLoaded: OnStyleLoaded?) throws {
    locale = l
    onStyleLoadedClosure = onStyleLoaded
    guard let sceneFile = styles.keyForValue(value: style) else { return }
    currentStyle = style
    try tgViewController.loadSceneFileAsync(sceneFile, sceneUpdates: allSceneUpdates(sceneUpdates))
  }

  /**
   Sets the locale used to determine the map's language.
   */
  open func updateLocale(_ l: Locale) {
    locale = l
    guard let language = locale.languageCode else { return }
    let update = createLanguageUpdate(language)
    queue([update])
    applySceneUpdates()
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
    guard currentLocationGem != nil else { return false }
    guard let point = lastSetPoint else { return false }
    //TODO: handle error?
//    if marker == 0 { return false } // Invalid Marker
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
      if !shouldShowCurrentLocation { return false }
      //TODO: handle error adding to map?
      let marker = SystemPointMarker.initWithMarkerType(.currentLocation)
      addMarker(marker)
      currentLocationGem = marker;
      locationManager.requestWhenInUseAuthorization()
      //Set visibility to false since we have to wait until we have an accurate location
      marker.visible = false
      return true
    }
    marker.visible = shouldShowCurrentLocation
    return true
  }

  /** 
   Enables / Disables the entire current location layer.
    
   - parameter enabled: True if we should enable the location layer. False disables it.
   */
  open func enableLocationLayer(_ enabled: Bool) {
    let _ = showCurrentLocation(enabled)
    showFindMeButon(enabled)
    enabled ? locationManager.startUpdatingLocation() : locationManager.stopUpdatingLocation()
    shouldFollowCurrentLocation = enabled
  }


  /** 
   Adds an array of annotations to the map.
   
   - parameter annotations: An array of annotations to add.
   - throws: A MZError `generalError` if the underlying map fails to add any of the annotations.
   */
  open func add(_ annotations: [PeliasMapkitAnnotation]) throws {
    for annotation in annotations {
      //TODO: handle error adding to map?
      let marker = SelectableSystemPointMarker.initWithMarkerType(.searchPin)
      addMarker(marker)
//      if newMarker == nil {
//        //TODO: Once TG integrates better error codes, we need to integrate that here.
//        // https://github.com/tangrams/tangram-es/issues/1219
//        throw NSError(domain: MZMapViewController.MapzenGeneralErrorDomain,
//                      code: MZError.generalError.rawValue,
//                      userInfo: nil)
//      }
      marker.point = TGGeoPoint(coordinate: annotation.coordinate)
      currentAnnotations[annotation] = marker.tgMarker
    }
  }

  /** 
   Removes a single annotation
   
   - parameter annotation: The annotation to remove
   - throws: A MZError `annotationDoesNotExist` error.
   */
  open func remove(_ annotation: PeliasMapkitAnnotation) throws {
    guard let marker = currentAnnotations[annotation] else { return }
    marker.map = nil
    //TODO: handle marker remove error?
//    if !tgViewController.markerRemove(markerId) {
//      throw NSError(domain: MZMapViewController.MapzenGeneralErrorDomain,
//                    code: MZError.annotationDoesNotExist.rawValue,
//                    userInfo: nil)
//    }
    currentAnnotations.removeValue(forKey: annotation)
  }

  /** 
   Removes all currents annotations.

   - throws: A MZError `annotationDoesNotExist` error if it encounters an annotation that no longer exists.
   */
  open func removeAnnotations() throws {
    for (annotation, marker) in currentAnnotations {
      marker.map = nil
      //TODO: handle marker remove error?
//      if !tgViewController.markerRemove(markerId) {
//        throw NSError(domain: MZMapViewController.MapzenGeneralErrorDomain,
//                      code: MZError.annotationDoesNotExist.rawValue,
//                      userInfo: nil)
//      }
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
      currentRoute = nil
      //TODO: handle marker remove error?
      removeMarker(routeMarker)
    }
    let routeLeg = route.legs[0]
    let polyLine = TGGeoPolyline(size: UInt32(routeLeg.coordinateCount))

    //TODO: Need to investigate more if this is a bug in OTR or if valhalla returns null island at the end of their requests?
    for index in 0...routeLeg.coordinateCount-1 {
      let point = routeLeg.coordinates?[Int(index)]
      print("Next Point: \(String(describing: point))")
      polyLine.add(TGGeoPoint(coordinate: point!))
    }
    let marker = SystemPolylineMarker.init()
    addMarker(marker)
    marker.polyline = polyLine
    currentRouteMarker = marker
    currentRoute = route
  }

  /**
   Removes the route from the map
   
   - throws: A MZError `routeDoesNotExist` error if there isn't a current route or the map can't find one to remove.
   */
  open func removeRoute() throws {

    guard let currentRouteMarker = currentRouteMarker else {
      throw NSError(domain: MZMapViewController.MapzenGeneralErrorDomain,
                    code: MZError.routeDoesNotExist.rawValue,
                    userInfo: nil)
    }

    removeMarker(currentRouteMarker)
    self.currentRouteMarker = nil
    currentRoute = nil
  }

  @objc func defaultFindMeAction(_ button: UIButton, touchEvent: UIEvent) {
    let _ = resetCameraOnCurrentLocation()
    button.isSelected = !button.isSelected
    shouldFollowCurrentLocation = button.isSelected
  }

  // MARK:- Memory Management handlers

  func reloadTGViewController() {
    guard let unwrappedSaver = stateSaver else { return }
    setupTgControllerView()
    tgViewController.gestureDelegate = self
    tgViewController.mapViewDelegate = self
    do {
      try loadStyleAsync(unwrappedSaver.mapStyle) { [unowned self] (styleLoaded) in
        self.recreateMap(unwrappedSaver)
        self.stateSaver = nil
      }
    } catch {
      // In the event Tangram can't do the reload, we're pretty much dead in the water.
      return
    }
  }

  //This function should really only be used in conjunction with reloadTGViewController, but it is safe to be used whenever.
  func recreateMap(_ state: StateReclaimer) {
    //Annotation Replay
    let oldAnnotations = self.currentAnnotations
    self.currentAnnotations = Dictionary()
    for (annotation, marker) in oldAnnotations {
      let newMarker = PointMarker.init()
      addMarker(newMarker)
      //TODO: also set polyline, polygon etc
      newMarker.point = marker.point
      if !marker.stylingPath.isEmpty {
        newMarker.tgMarker.stylingPath = marker.stylingPath
      } else {
        newMarker.tgMarker.stylingString = marker.stylingString
      }
      self.currentAnnotations[annotation] = newMarker.tgMarker
    }

    //Routing Replay
    if let currentRoute = self.currentRoute {
      do {
        try self.display(currentRoute)
      } catch {
        //Silently catch this - we may still be able to recover from here sans route
      }
    }

    //State Reset
    self.tilt = state.tilt
    self.rotation = state.rotation
    self.zoom = state.zoom
    self.position = state.position
    self.cameraType = state.cameraType

    // Location Marker reset
    if shouldShowCurrentLocation {
      if let locGem = currentLocationGem {
        addMarker(locGem)
      }
      _ = self.showCurrentLocation(true)
    }

    //Button Setup
    self.setupAttribution()
    let originalButton = findMeButton
    self.setupFindMeButton()
    findMeButton.isHidden = originalButton.isHidden
    findMeButton.isSelected = shouldFollowCurrentLocation
    findMeButton.isEnabled = originalButton.isEnabled
  }

  // MARK:- ViewController Lifecycle

  override open func viewDidLoad() {
    super.viewDidLoad()
    locationManager.delegate = self
    setupTgControllerView()
    setupAttribution()
    setupFindMeButton()

    tgViewController.gestureDelegate = self
    tgViewController.mapViewDelegate = self
  }

  override open func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    //We only want to attempt to reload incase we reloaded due to memory issues
    if (stateSaver != nil) {
      print("reloading tgviewcontroller due to memory warning removal")
      reloadTGViewController()
    }
  }

  override open func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    isCurrentlyVisible = true
  }

  override open func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    isCurrentlyVisible = false
  }

  override open func didReceiveMemoryWarning() {
    if (!isCurrentlyVisible) {
      tgViewController.willMove(toParentViewController: nil)
      tgViewController.view.removeConstraints(tgViewController.view.constraints)
      tgViewController.view.removeFromSuperview()
      tgViewController.removeFromParentViewController()
      stateSaver = StateReclaimer(tilt: tilt, rotation: rotation, zoom: zoom, position: position, cameraType: cameraType, mapStyle: currentStyle)
      //Probably unnecessary, but just incase we don't want any calls coming through from older versions that the OS has yet to clean up
      tgViewController.gestureDelegate = nil
      tgViewController.mapViewDelegate = nil
      if let locGem = currentLocationGem {
        removeMarker(locGem)
      }
      tgViewController = TGMapViewController()
    }
    super.didReceiveMemoryWarning()
  }

  //MARK: - LocationManagerDelegate

  open func locationDidUpdate(_ location: CLLocation) {
    guard let marker = currentLocationGem else {
      return
    }
    lastSetPoint = TGGeoPoint(longitude: location.coordinate.longitude, latitude: location.coordinate.latitude)
    marker.point = TGGeoPoint(longitude: location.coordinate.longitude, latitude: location.coordinate.latitude)
    if (shouldShowCurrentLocation) {
      marker.visible = true
    }

    if (shouldFollowCurrentLocation) {
      print("Updating for current lat: \(location.coordinate.latitude) & long: \(location.coordinate.longitude)")
      let _ = resetCameraOnCurrentLocation()
    }
  }

  open func authorizationDidSucceed() {
    locationManager.startUpdatingLocation()
    locationManager.requestLocation()
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
    //TODO: handle error?
    removeMarker(marker)
    return
  }

  //MARK: - private

  private func setupTgControllerView() {
    addChildViewController(tgViewController)

    self.view.addSubview(tgViewController.view)
    self.view.sendSubview(toBack: tgViewController.view)

    tgViewController.view.translatesAutoresizingMaskIntoConstraints = false

    let leftConstraint = tgViewController.view.leftAnchor.constraint(equalTo: view.leftAnchor)
    let rightConstraint = tgViewController.view.rightAnchor.constraint(equalTo: view.rightAnchor)
    let topConstraint = tgViewController.view.topAnchor.constraint(equalTo: view.topAnchor)
    let bottomConstraint = tgViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    NSLayoutConstraint.activate([leftConstraint, rightConstraint, topConstraint, bottomConstraint])

    tgViewController.didMove(toParentViewController: self)
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

    let bottomOffset = -Dimensions.defaultPadding - tabBarOffset
    let horizontalConstraint = attributionBtn.leftAnchor.constraint(equalTo: mapView.leftAnchor, constant: Dimensions.defaultPadding)
    let verticalConstraint = attributionBtn.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: bottomOffset)
    NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint])
  }

  func setupFindMeButton() {
    findMeButton = UIButton(type: UIButtonType.custom)
    findMeButton.addTarget(self, action: #selector(MZMapViewController.defaultFindMeAction(_:touchEvent:)), for: .touchUpInside)
    findMeButton.isEnabled = false
    findMeButton.isHidden = true
    findMeButton.adjustsImageWhenHighlighted = false
    if let imgNormalName = Bundle.mapzenBundle().path(forResource: "ic_find_me_normal", ofType: "png") {
      findMeButton.setBackgroundImage(UIImage(named: imgNormalName), for: UIControlState())
    }
    //TODO: This should also have .Highlighted as well .Selected , but something about the @3x assets and UIButton is misbehaving; might need bug opened with Apple.
    if let imgPressedName = Bundle.mapzenBundle().path(forResource: "ic_find_me_pressed", ofType: "png") {
      findMeButton.setBackgroundImage(UIImage(named: imgPressedName), for: [.selected])
    }
    findMeButton.backgroundColor = UIColor.white
    //findMeButton.autoresizingMask = [.flexibleTopMargin, .flexibleLeftMargin]
    findMeButton.translatesAutoresizingMaskIntoConstraints = false
    mapView.addSubview(findMeButton)

    let bottomOffset = -Dimensions.defaultPadding - tabBarOffset
    let horizontalConstraint = findMeButton.rightAnchor.constraint(equalTo: mapView.rightAnchor, constant: -Dimensions.defaultPadding)
    let verticalConstraint = findMeButton.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: bottomOffset)
    let widthConstraint = findMeButton.widthAnchor.constraint(equalToConstant: Dimensions.squareMapBtnSize)
    let heightConstraint = findMeButton.widthAnchor.constraint(equalToConstant: Dimensions.squareMapBtnSize)
    NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
  }

  @objc private func openMapzenTerms() {
    guard let url = URL(string: MZMapViewController.mapzenRights) else { return }
    let _ = application.openURL(url)
  }

  private func allSceneUpdates(_ sceneUpdates: [TGSceneUpdate]) throws -> [TGSceneUpdate] {
    guard let apiKey = mapzenManager.apiKey else {
      throw NSError(domain: MZMapViewController.MapzenGeneralErrorDomain,
                    code: MZError.apiKeyNotSet.rawValue,
                    userInfo: nil)
    }
    var allSceneUpdates = [TGSceneUpdate]()
    allSceneUpdates.append(contentsOf: sceneUpdates)
    allSceneUpdates.append(TGSceneUpdate(path: MZMapViewController.kGlobalPathApiKey, value: "'\(apiKey)'"))
    if let language = locale.languageCode {
      allSceneUpdates.append(createLanguageUpdate(language))
    }
    return allSceneUpdates
  }

  private func createLanguageUpdate(_ language: String) -> TGSceneUpdate {
    return TGSceneUpdate(path: MZMapViewController.kGlobalPathLanguage, value: language)
  }
}

extension MZMapViewController : TGMapViewDelegate, TGRecognizerDelegate {
  
  //MARK : TGMapViewDelegate
  
  open func mapView(_ mapView: TGMapViewController, didLoadSceneAsync scene: String) {
    // if we loaded a house style scene looks something like: file:///var/containers/Bundle/Application/FAFA232A-1190-40CB-9391-7C9F44B51076/ios-sdk.app/housestyles.bundle/bubble-wrap/bubble-wrap-style-more-labels.yaml
    guard let pathComponents = URL.init(string: scene)?.pathComponents else {
      onStyleLoadedClosure = nil
      return
    }
    // if we have path components, grab the last two (ie. bubble-wrap & bubble-wrap-style-more-labels.yaml), strip ".yaml" and check for existence in styles map
    let sceneStyle = (pathComponents[pathComponents.count-2] + "/" + pathComponents.last!).replacingOccurrences(of: ".yaml", with: "")
    guard let style = styles[sceneStyle] else {
      onStyleLoadedClosure = nil
      return
    }
    onStyleLoadedClosure?(style)
    onStyleLoadedClosure = nil
  }
  
  open func mapViewDidCompleteLoading(_ mapView: TGMapViewController) {
    tileLoadDelegate?.mapControllerDidCompleteLoading(self)
  }
  
  open func mapView(_ mapView: TGMapViewController, didSelectFeature feature: [String : String]?, atScreenPosition position: CGPoint) {
    guard let feature = feature else { return }
    featureSelectDelegate?.mapController(self, didSelectFeature: feature, atScreenPosition: position)
  }
  
  open func mapView(_ mapView: TGMapViewController, didSelectLabel labelPickResult: TGLabelPickResult?, atScreenPosition position: CGPoint) {
    guard let labelPickResult = labelPickResult else { return }
    labelSelectDelegate?.mapController(self, didSelectLabel: labelPickResult, atScreenPosition: position)
  }
  
  open func mapView(_ mapView: TGMapViewController, didSelectMarker markerPickResult: TGMarkerPickResult?, atScreenPosition position: CGPoint) {
    guard let markerPickResult = markerPickResult else { return }
    let tgMarker = markerPickResult.marker
    guard let annotation = currentAnnotations.keyForValue(value: tgMarker) else {
      if let marker = currentMarkers[tgMarker] {
        markerSelectDelegate?.mapController(self, didSelectMarker: marker, atScreenPosition: position)
      }
      return
    }
    if let target = annotation.target, let action = annotation.selector {
      if target.canPerformAction(action, withSender: annotation) {
        _ = target.perform(action, with: annotation)
      } else {
        _ = target.perform(action)
      }
    }
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

