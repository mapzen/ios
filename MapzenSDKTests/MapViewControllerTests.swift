//
//  MapViewControllerTests.swift
//  ios-sdk
//
//  Created by Matt Smollinger on 12/21/16.
//  Copyright © 2016 Mapzen. All rights reserved.
//

import XCTest
@testable import ios_sdk
import TangramMap
import OnTheRoad
import CoreLocation

class TestMapViewController: MZMapViewController {
  func lastSetPointValue() -> TGGeoPoint? {
    return lastSetPoint
  }
  func currentLocationGemValue() -> GenericMarker? {
    return currentLocationGem
  }
  func shouldShowCurrentLocationValue() -> Bool {
    return shouldShowCurrentLocation
  }
}

class MockHTTPHandler: TGHttpHandler {
  override open func downloadRequestAsync(_ url: String, completionHandler: @escaping TangramMap.TGDownloadCompletionHandler) {
    //We want Tangram to stay off the network in unit testing, so we no-op this to make certain
  }
}

class MapViewControllerTests: XCTestCase {

  let testApplication = TestApplication()
  let testLocationManager = TestLocationManager()
  let testMapzenManager = TestMapzenManager()
  var controller = TestMapViewController()
  var tgViewController = TestTGMapViewController()
  let mockLocation = CLLocation(latitude: 0.0, longitude: 0.0) // Null Island!
  let apiKey = "testKey"

  override func setUp() {
    testMapzenManager.apiKey = apiKey
    controller = TestMapViewController(applicationProtocol: testApplication, locationManagerProtocol: testLocationManager, mapzenManagerProtocol: testMapzenManager)
    controller.tgViewController = tgViewController
    let mockHTTP = MockHTTPHandler()
    controller.tgViewController.httpHandler = mockHTTP

    _ = controller.view
  }

  func testInit() {
    XCTAssertNotNil(controller)
    XCTAssertFalse(controller.shouldFollowCurrentLocation)
  }

  func testChildVc() {
    XCTAssertTrue(controller.childViewControllers.contains(tgViewController))
  }
  
  func testAnimateToPosition() {
    let point = TGGeoPoint(longitude: 70.0, latitude: 40.0)
    controller.animate(toPosition: point, withDuration: 3)
    XCTAssertEqual(tgViewController.coordinate.longitude, 70.0)
    XCTAssertEqual(tgViewController.coordinate.latitude, 40.0)
    XCTAssertEqual(tgViewController.duration, 3)
  }
  
  func testAnimateToPositionWithEase() {
    let point = TGGeoPoint(longitude: 70.0, latitude: 40.0)
    controller.animate(toPosition: point, withDuration: 3, with: TGEaseType.cubic)
    XCTAssertEqual(tgViewController.coordinate.longitude, 70.0)
    XCTAssertEqual(tgViewController.coordinate.latitude, 40.0)
    XCTAssertEqual(tgViewController.duration, 3)
    XCTAssertEqual(tgViewController.easeType, TGEaseType.cubic)
  }

  func testAnimateToZoom() {
    controller.animate(toZoomLevel: 1.0, withDuration: 2.0)
    XCTAssertEqual(tgViewController.zoom, 1.0)
    XCTAssertEqual(tgViewController.duration, 2.0)
  }

  func testAnimateToZoomWithEase() {
    controller.animate(toZoomLevel: 1.0, withDuration: 2.0, with: TGEaseType.cubic)
    XCTAssertEqual(tgViewController.zoom, 1.0)
    XCTAssertEqual(tgViewController.duration, 2.0)
    XCTAssertEqual(tgViewController.easeType, TGEaseType.cubic)
  }
  
  func testAnimateToRotation() {
    controller.animate(toRotation: 1.0, withDuration: 9.0)
    XCTAssertEqual(tgViewController.rotation, 1.0)
    XCTAssertEqual(tgViewController.duration, 9.0)
  }
  
  func testAnimateToRotationWithEase() {
    controller.animate(toRotation: 1.0, withDuration: 9.0, with: TGEaseType.linear)
    XCTAssertEqual(tgViewController.rotation, 1.0)
    XCTAssertEqual(tgViewController.duration, 9.0)
    XCTAssertEqual(tgViewController.easeType, TGEaseType.linear)
  }
  
  func testAnimateToTilt() {
    controller.animate(toTilt: 3.0, withDuration: 4.0)
    XCTAssertEqual(tgViewController.tilt, 3.0)
    XCTAssertEqual(tgViewController.duration, 4.0)
  }
  
  func testAnimateToTiltWithEase() {
    controller.animate(toTilt: 3.0, withDuration: 4.0, with: TGEaseType.sine)
    XCTAssertEqual(tgViewController.tilt, 3.0)
    XCTAssertEqual(tgViewController.duration, 4.0)
    XCTAssertEqual(tgViewController.easeType, TGEaseType.sine)
  }
  
  func testMarkerRemoveAll() {
    controller.markerRemoveAll()
    XCTAssertTrue(tgViewController.removedAllMarkers)
  }

  func testLoadBubbleWrap() {
    try? controller.loadStyle(.bubbleWrap)
    XCTAssertTrue(tgViewController.scenePath.contains("bubble-wrap/bubble-wrap-style-more-labels.yaml"))
    XCTAssertEqual(controller.currentStyle, .bubbleWrap)
  }

  func testLoadCinnabar() {
    try? controller.loadStyle(.cinnabar)
    XCTAssertTrue(tgViewController.scenePath.contains("cinnabar/cinnabar-style-more-labels.yaml"))
    XCTAssertEqual(controller.currentStyle, .cinnabar)
  }

  func testLoadRefill() {
    try? controller.loadStyle(.refill)
    XCTAssertTrue(tgViewController.scenePath.contains("refill/refill-style-more-labels.yaml"))
    XCTAssertEqual(controller.currentStyle, .refill)
  }

  func testLoadWalkabout() {
    try? controller.loadStyle(.walkabout)
    XCTAssertTrue(tgViewController.scenePath.contains("walkabout/walkabout-style-more-labels.yaml"))
    XCTAssertEqual(controller.currentStyle, .walkabout)
  }

  func testLoadZinc() {
    try? controller.loadStyle(.zinc)
    XCTAssertTrue(tgViewController.scenePath.contains("zinc/zinc-style-more-labels.yaml"))
    XCTAssertEqual(controller.currentStyle, .zinc)
  }
  
  func testLoadStyleWithUpdates() {
    let update = TGSceneUpdate(path: "path", value: "value")
    var updates = [TGSceneUpdate]()
    updates.append(update)
    try? controller.loadStyle(.bubbleWrap, sceneUpdates: updates)
    XCTAssertTrue(tgViewController.scenePath.contains("bubble-wrap/bubble-wrap-style-more-labels.yaml"))
    XCTAssertEqual(tgViewController.sceneUpdates.count, 3)
    XCTAssertTrue(tgViewController.sceneUpdates.contains(update))
    let apiKeyUpdate = tgViewController.sceneUpdates.filter { (update) -> Bool in
      return update.path == "global.sdk_mapzen_api_key"
    }.first
    XCTAssertEqual(apiKeyUpdate?.value, "'\(apiKey)'")
  }
  
  func testLoadStyleAsync() {
    try? controller.loadStyleAsync(.bubbleWrap, onStyleLoaded: nil)
    XCTAssertTrue(tgViewController.scenePath.contains("bubble-wrap-style-more-labels.yaml"))
  }

  func testLoadStyleAsyncWithUpdates() {
    let update = TGSceneUpdate(path: "path", value: "value")
    var updates = [TGSceneUpdate]()
    updates.append(update)
    try? controller.loadStyleAsync(.bubbleWrap, sceneUpdates: updates, onStyleLoaded: nil)
    XCTAssertTrue(tgViewController.scenePath.contains("bubble-wrap/bubble-wrap-style-more-labels.yaml"))
    XCTAssertEqual(tgViewController.sceneUpdates.count, 3)
    XCTAssertTrue(tgViewController.sceneUpdates.contains(update))
    let apiKeyUpdate = tgViewController.sceneUpdates.filter { (update) -> Bool in
      return update.path == "global.sdk_mapzen_api_key"
      }.first
    XCTAssertEqual(apiKeyUpdate?.value, "'\(apiKey)'")
  }

  func testCurrentLocaleIsDefault() {
    try? controller.loadStyleAsync(.bubbleWrap, onStyleLoaded: nil)
    XCTAssertEqual(tgViewController.sceneUpdates.last?.path, "global.ux_language")
    XCTAssertEqual(tgViewController.sceneUpdates.last?.value, Locale.current.languageCode)
  }

  func testLoadStyleLocaleIsSet() {
    let locale = Locale.init(identifier: "ja-JP")
    try? controller.loadStyle(.bubbleWrap, locale: locale)
    XCTAssertEqual(tgViewController.sceneUpdates.last?.path, "global.ux_language")
    XCTAssertEqual(tgViewController.sceneUpdates.last?.value, locale.languageCode)
  }

  func testLoadStyleWithSceneUpdatesLocaleIsSet() {
    let locale = Locale.init(identifier: "ja-JP")
    try? controller.loadStyle(.bubbleWrap, locale: locale, sceneUpdates: [])
    XCTAssertEqual(tgViewController.sceneUpdates.last?.path, "global.ux_language")
    XCTAssertEqual(tgViewController.sceneUpdates.last?.value, locale.languageCode)
  }

  func testLoadStyleAsyncLocaleIsSet() {
    let locale = Locale.init(identifier: "ja-JP")
    try? controller.loadStyleAsync(.bubbleWrap, locale: locale, onStyleLoaded: nil)
    XCTAssertEqual(tgViewController.sceneUpdates.last?.path, "global.ux_language")
    XCTAssertEqual(tgViewController.sceneUpdates.last?.value, locale.languageCode)
  }

  func testLoadStyleWithSceneUpdatesAsyncLocaleIsSet() {
    let locale = Locale.init(identifier: "ja-JP")
    try? controller.loadStyleAsync(.bubbleWrap, locale: locale, sceneUpdates: [], onStyleLoaded: nil)
    XCTAssertEqual(tgViewController.sceneUpdates.last?.path, "global.ux_language")
    XCTAssertEqual(tgViewController.sceneUpdates.last?.value, locale.languageCode)
  }

  func testUpdateLocaleSetsCorrectLangage() {
    let locale = Locale.init(identifier: "hi-IN")
    controller.updateLocale(locale)
    XCTAssertEqual(tgViewController.sceneUpdates.last?.value, locale.languageCode)

    let anotherLocale = Locale.init(identifier: "ja-JP")
    controller.updateLocale(anotherLocale)
    XCTAssertEqual(tgViewController.sceneUpdates.last?.value, anotherLocale.languageCode)
  }

  func testQueueSceneUpdate() {
    controller.queueSceneUpdate("path", withValue: "value")
    XCTAssertEqual(tgViewController.sceneUpdateComponentPath, "path")
    XCTAssertEqual(tgViewController.sceneUpdateValue, "value")
  }

  func testQueueSceneUpdates() {
    let updates = [TGSceneUpdate]()
    controller.queue(updates)
    XCTAssertEqual(tgViewController.sceneUpdates, updates)
    
  }
  
  func testApplySceneUpdates() {
    controller.applySceneUpdates()
    XCTAssertTrue(tgViewController.appliedSceneUpdates)
  }

  func testTiltProperty() {
    controller.tilt = 1.0
    XCTAssertEqual(controller.tilt, 1.0)
  }

  func testRotationProperty() {
    controller.rotation = 1.0
    XCTAssertEqual(controller.rotation, 1.0)
  }

  func testZoomProperty() {
    controller.zoom = 1.0
    XCTAssertEqual(controller.zoom, 1.0)
  }

  func testCameraTypeProperty() {
    controller.cameraType = .flat
    XCTAssertEqual(controller.cameraType, .flat)
  }

  func testPositionProperty() {
    let point = TGGeoPointMake(1.0, 2.0)
    controller.position = point
    //We don't check latitude because of an underlying precision issue with Tangram. More investigation needed.
    XCTAssertEqualWithAccuracy(controller.position.longitude, point.longitude, accuracy: DBL_EPSILON)
  }

  func testLngLatToScreenPosition() {
    let point = TGGeoPointMake(70.0, 40.0)
    let _ = controller.lngLat(toScreenPosition: point)
    XCTAssertEqual(tgViewController.lngLatForScreenPosition.longitude, 70.0)
    XCTAssertEqual(tgViewController.lngLatForScreenPosition.latitude, 40.0)
  }

  func testScreenPositionToLngLat() {
    let point = CGPoint(x: 1, y: 2)
    let _ = controller.screenPosition(toLngLat: point)
    XCTAssertEqual(tgViewController.screenPositionForLngLat, point)
  }
  
  func testFindMeButtonInitialState() {
    controller.setupFindMeButton()
    //Test Initial State
    XCTAssertTrue(controller.findMeButton.isHidden)
    XCTAssertFalse(controller.findMeButton.isEnabled)
    XCTAssertFalse(controller.findMeButton.adjustsImageWhenHighlighted)
  }

  func testShowFindMeButton() {
    //Setup
    controller.showFindMeButon(true)

    //Tests
    XCTAssertFalse(controller.findMeButton.isHidden)
    XCTAssertTrue(controller.findMeButton.isEnabled)

    //Now for flipping it back to false
    controller.showFindMeButon(false)

    //Tests
    XCTAssertTrue(controller.findMeButton.isHidden)
    XCTAssertFalse(controller.findMeButton.isEnabled)
  }

  func testInitialLocationState() {
    XCTAssertFalse(controller.shouldFollowCurrentLocation)
    XCTAssertFalse(controller.shouldShowCurrentLocationValue())
    XCTAssertNil(controller.currentLocationGemValue())
    XCTAssertNil(controller.lastSetPointValue())
    XCTAssertNil(controller.currentLocationGemValue())
  }

  func testDisabledLocation() {
    controller.enableLocationLayer(false)
    XCTAssertFalse(testLocationManager.requestedInUse)
    XCTAssertNil(controller.currentLocationGem)
    XCTAssertTrue(controller.findMeButton.isHidden)
    XCTAssertFalse(controller.shouldFollowCurrentLocation)
    XCTAssertFalse(controller.shouldShowCurrentLocationValue())
  }

  func testEnableLocation() {
    controller.enableLocationLayer(true)

    //Tests
    XCTAssertTrue(testLocationManager.requestedInUse)
    XCTAssertFalse(controller.findMeButton.isHidden)
    XCTAssertTrue(controller.shouldFollowCurrentLocation)
    XCTAssertTrue(controller.shouldShowCurrentLocationValue())
  }

  func testDisableLocation() {
    //Setup
    controller.enableLocationLayer(true)
    controller.enableLocationLayer(false)

    //Tests
    XCTAssertTrue(testLocationManager.requestedInUse)
    XCTAssertTrue(controller.findMeButton.isHidden)
    XCTAssertFalse(controller.shouldFollowCurrentLocation)
    XCTAssertFalse(controller.shouldShowCurrentLocationValue())
  }

  func testShowCurrentLocation() {
    //Tests
    XCTAssertTrue(controller.showCurrentLocation(true))
    XCTAssertNotNil(controller.currentLocationGemValue())
    XCTAssertTrue(controller.shouldShowCurrentLocationValue())
    XCTAssertTrue(controller.currentLocationGemValue() != nil)
  }

  func testLocationUpdateSansMarkerGeneration() {
    //Setup
    controller.locationDidUpdate(mockLocation)

    //Tests
    XCTAssertNil(controller.lastSetPointValue())
    XCTAssertNil(controller.currentLocationGemValue())
  }

  func testLocationUpdateWithMarkerGeneration() {
    //Setup
    let _ = controller.showCurrentLocation(true)
    controller.locationDidUpdate(mockLocation)

    //Tests
    XCTAssertNotNil(controller.lastSetPointValue())
    XCTAssertTrue(controller.lastSetPointValue()?.latitude == mockLocation.coordinate.latitude)
    XCTAssertTrue(controller.lastSetPointValue()?.longitude == mockLocation.coordinate.longitude)
  }

  func testAddAnnotations(){
    let testAnno1 = PeliasMapkitAnnotation(coordinate: CLLocationCoordinate2DMake(0.0, 0.0), title: "Test1", subtitle: "SubTest1", data: nil)
    let testAnno2 = PeliasMapkitAnnotation(coordinate: CLLocationCoordinate2DMake(1.0, 1.0), title: "Test2", subtitle: "SubTest2", data: nil)
    let controller = MZMapViewController() // Grab local instance cuz we don't want to use mocks for these
    let _ = try? controller.add([testAnno1, testAnno2])

    //Tests
    let marker1Id = controller.currentAnnotations[testAnno1]!
    let marker2Id = controller.currentAnnotations[testAnno2]!
    XCTAssertNotNil(marker1Id)
    XCTAssertNotNil(marker2Id)
  }

  func testRemoveSingleAnnotation(){
    let testAnno1 = PeliasMapkitAnnotation(coordinate: CLLocationCoordinate2DMake(0.0, 0.0), title: "Test1", subtitle: "SubTest1", data: nil)
    let controller = MZMapViewController() // Grab local instance cuz we don't want to use mocks for these

    //Tests
    let _ = try? controller.remove(testAnno1)
    XCTAssertNil(controller.currentAnnotations[testAnno1])
  }

  func testRemoveAllAnnotations(){
    let testAnno1 = PeliasMapkitAnnotation(coordinate: CLLocationCoordinate2DMake(0.0, 0.0), title: "Test1", subtitle: "SubTest1", data: nil)
    let testAnno2 = PeliasMapkitAnnotation(coordinate: CLLocationCoordinate2DMake(1.0, 1.0), title: "Test2", subtitle: "SubTest2", data: nil)
    let controller = MZMapViewController() // Grab local instance cuz we don't want to use mocks for these
    let _ = try? controller.add([testAnno1, testAnno2])

    //Tests
    let _ = try? controller.removeAnnotations()
    XCTAssertNil(controller.currentAnnotations[testAnno1])
    XCTAssertNil(controller.currentAnnotations[testAnno2])
  }

  func testAnnotationSelectorCallsSelector() {
    let annotation = PeliasMapkitAnnotation(coordinate: CLLocationCoordinate2DMake(0.0, 0.0), title: "Title", subtitle: "Subtitle", data: nil)
    let target = AnnotationTestTarget()
    controller.markerSelectDelegate = target
    annotation.setTarget(target: target, action: #selector(target.annotationClickedNoParams))

    try? controller.add([annotation])
    let markerPickResult = TestTGMarkerPickResult.init(marker: controller.currentAnnotations[annotation]!)
    controller.mapView(tgViewController, didSelectMarker: markerPickResult, atScreenPosition: CGPoint())
    XCTAssertTrue(target.annotationClickedNoParam)
    XCTAssertFalse(target.annotationClicked)
    XCTAssertFalse(target.markerSelected)
  }

  func testAnnotationSelectorCallsSelectorWithObject() {
    let annotation = PeliasMapkitAnnotation(coordinate: CLLocationCoordinate2DMake(0.0, 0.0), title: "Title", subtitle: "Subtitle", data: nil)
    let target = AnnotationTestTarget()
    controller.markerSelectDelegate = target
    annotation.setTarget(target: target, action: #selector(target.annotationClicked(annotation:)))

    try? controller.add([annotation])
    let markerPickResult = TestTGMarkerPickResult.init(marker: controller.currentAnnotations[annotation]!)
    controller.mapView(tgViewController, didSelectMarker: markerPickResult, atScreenPosition: CGPoint())
    XCTAssertTrue(target.annotationClicked)
    XCTAssertFalse(target.annotationClickedNoParam)
    XCTAssertFalse(target.markerSelected)
  }

  func testPanEnabledByDefault() {
    XCTAssertTrue(controller.panEnabled)
  }
  
  func testPinchEnabledByDefault() {
    XCTAssertTrue(controller.pinchEnabled)
  }
  
  func testRotateEnabledByDefault() {
    XCTAssertTrue(controller.rotateEnabled)
  }
  
  func testShoveEnabledByDefault() {
    XCTAssertTrue(controller.shoveEnabled)
  }
  
  func testPanDisabledShouldNotRecognizePan() {
    controller.panEnabled = false
    let recognize = controller.mapView(controller.tgViewController, recognizer: UIGestureRecognizer(), shouldRecognizePanGesture: CGPoint())
    XCTAssertFalse(recognize)
  }
  
  func testPinchDisabledShouldNotRecognizePinch() {
    controller.pinchEnabled = false
    let recognize = controller.mapView(controller.tgViewController, recognizer: UIGestureRecognizer(), shouldRecognizePinchGesture: CGPoint())
    XCTAssertFalse(recognize)
  }
  
  func testRotateDisabledShouldNotRecognizeRotate() {
    controller.rotateEnabled = false
    let recognize = controller.mapView(controller.tgViewController, recognizer: UIGestureRecognizer(), shouldRecognizeRotationGesture: CGPoint())
    XCTAssertFalse(recognize)
  }
  
  func testShoveDisabledShouldNotRecognizeShove() {
    controller.shoveEnabled = false
    let recognize = controller.mapView(controller.tgViewController, recognizer: UIGestureRecognizer(), shouldRecognizeShoveGesture: CGPoint())
    XCTAssertFalse(recognize)
  }
    
  func testPanReceivedShouldCallDelegate() {
    let delegate = TestPanDelegate()
    controller.panDelegate = delegate
    controller.mapView(controller.tgViewController, recognizer: UIGestureRecognizer(), didRecognizePanGesture: CGPoint())
    XCTAssertTrue(delegate.didPanMap)
  }
  
  func testPanReceivedShouldDisableCurrentLocation() {
    controller.shouldFollowCurrentLocation = true
    controller.mapView(controller.tgViewController, recognizer: UIGestureRecognizer(), didRecognizePanGesture: CGPoint())
    XCTAssertFalse(controller.shouldFollowCurrentLocation)
  }
  
  func testPanReceivedShouldDeselectFindMe() {
    controller.findMeButton.isSelected = true
    controller.mapView(controller.tgViewController, recognizer: UIGestureRecognizer(), didRecognizePanGesture: CGPoint())
    XCTAssertFalse(controller.findMeButton.isSelected)
  }
  
  func testPanDisabledShouldDisableCurrentLocation() {
    controller.panEnabled = false
    controller.shouldFollowCurrentLocation = true
    let _ = controller.mapView(controller.tgViewController, recognizer: UIGestureRecognizer(), shouldRecognizePanGesture: CGPoint())
    XCTAssertFalse(controller.shouldFollowCurrentLocation)
  }
  
  func testPanDisabledShouldDeselectFindMe() {
    controller.panEnabled = false
    controller.findMeButton.isSelected = true
    let _ = controller.mapView(controller.tgViewController, recognizer: UIGestureRecognizer(), shouldRecognizePanGesture: CGPoint())
    XCTAssertFalse(controller.findMeButton.isSelected)
  }
  
  func testPinchReceivedShouldCallDelegate() {
    let delegate = TestPinchDelegate()
    controller.pinchDelegate = delegate
    controller.mapView(controller.tgViewController, recognizer: UIGestureRecognizer(), didRecognizePinchGesture: CGPoint())
    XCTAssertTrue(delegate.didPinchMap)
  }
  
  func testRotateReceivedShouldCallDelegate() {
    let delegate = TestRotateDelegate()
    controller.rotateDelegate = delegate
    controller.mapView(controller.tgViewController, recognizer: UIGestureRecognizer(), didRecognizeRotationGesture: CGPoint())
    XCTAssertTrue(delegate.didRotateMap)
  }
  
  func testShoveReceivedShouldCallDelegate() {
    let delegate = TestShoveDelegate()
    controller.shoveDelegate = delegate
    controller.mapView(controller.tgViewController, recognizer: UIGestureRecognizer(), didRecognizeShoveGesture: CGPoint())
    XCTAssertTrue(delegate.didShoveMap)
  }
  
  func testSingleTapRecognizedShouldCallDelegate() {
    let delegate = AllEnabledGestureDelegate()
    controller.singleTapGestureDelegate = delegate
    controller.mapView(controller.tgViewController, recognizer: UIGestureRecognizer(), didRecognizeSingleTapGesture: CGPoint())
    XCTAssertTrue(delegate.singleTapReceived)
  }
  
  func testDoubleTapRecognizedShouldCallDelegate() {
    let delegate = AllEnabledGestureDelegate()
    controller.doubleTapGestureDelegate = delegate
    controller.mapView(controller.tgViewController, recognizer: UIGestureRecognizer(), didRecognizeDoubleTapGesture: CGPoint())
    XCTAssertTrue(delegate.doubleTapReceived)
  }
  
  func testLongPressRecognizedShouldCallDelegate() {
    let delegate = AllEnabledGestureDelegate()
    controller.longPressGestureDelegate = delegate
    controller.mapView(controller.tgViewController, recognizer: UIGestureRecognizer(), didRecognizeLongPressGesture: CGPoint())
    XCTAssertTrue(delegate.longPressTapReceived)
  }
  
  func testSingleTapRecognizedShouldNotCallDelegate() {
    let delegate = AllDisabledGestureDelegate()
    controller.mapView(controller.tgViewController, recognizer: UIGestureRecognizer(), didRecognizeSingleTapGesture: CGPoint())
    XCTAssertFalse(delegate.singleTapReceived)
  }
  
  func testDoubleTapRecognizedShouldNotCallDelegate() {
    let delegate = AllDisabledGestureDelegate()
    controller.mapView(controller.tgViewController, recognizer: UIGestureRecognizer(), didRecognizeDoubleTapGesture: CGPoint())
    XCTAssertFalse(delegate.doubleTapReceived)
  }
  
  func testLongPressRecognizedShouldNotCallDelegate() {
    let delegate = AllDisabledGestureDelegate()
    controller.mapView(controller.tgViewController, recognizer: UIGestureRecognizer(), didRecognizeLongPressGesture: CGPoint())
    XCTAssertFalse(delegate.longPressTapReceived)
  }
  
  func testShouldNotRecognizeSingleTapPicksLabel() {
    let delegate = AllDisabledGestureDelegate()
    controller.singleTapGestureDelegate = delegate
    let _ = controller.mapView(controller.tgViewController, recognizer: UIGestureRecognizer(), shouldRecognizeSingleTapGesture: CGPoint(x: 30, y: 40))
    XCTAssertEqual(tgViewController.labelPickPosition.x, 30)
    XCTAssertEqual(tgViewController.labelPickPosition.y, 40)
  }
  
  func testShouldNotRecognizePicksMarker() {
    let delegate = AllDisabledGestureDelegate()
    controller.singleTapGestureDelegate = delegate
    let _ = controller.mapView(controller.tgViewController, recognizer: UIGestureRecognizer(), shouldRecognizeSingleTapGesture: CGPoint(x: 30, y: 40))
    XCTAssertEqual(tgViewController.markerPickPosition.x, 30)
    XCTAssertEqual(tgViewController.markerPickPosition.y, 40)
  }
  
  func testShouldNotRecognizePicksFeature() {
    let delegate = AllDisabledGestureDelegate()
    controller.singleTapGestureDelegate = delegate
    let _ = controller.mapView(controller.tgViewController, recognizer: UIGestureRecognizer(), shouldRecognizeSingleTapGesture: CGPoint(x: 30, y: 40))
    XCTAssertEqual(tgViewController.featurePickPosition.x, 30)
    XCTAssertEqual(tgViewController.featurePickPosition.y, 40)
  }
  
  func testLoadStyleAsyncCallsLoadDelegate() {
    var loaded = false
    let styleLoaded : MZMapViewController.OnStyleLoaded = { (style) in loaded = true }
    try? controller.loadStyleAsync(.bubbleWrap, onStyleLoaded: styleLoaded)
    controller.mapView(controller.tgViewController, didLoadSceneAsync: "/test/container/bubble-wrap/bubble-wrap-style-more-labels.yaml")
    XCTAssertTrue(loaded)
  }
  
  func testDidCompleteLoadingCallsLoadDelegate() {
    let delegate = TestLoadDelegate()
    controller.tileLoadDelegate = delegate
    controller.mapViewDidCompleteLoading(controller.tgViewController)
    XCTAssertTrue(delegate.loadingComplete)
  }
  
  func testDidSelectLabelCallsSelectDelegate() {
    let delegate = TestMapSelectDelegate()
    controller.labelSelectDelegate = delegate
    controller.mapView(tgViewController, didSelectLabel: TGLabelPickResult(), atScreenPosition: CGPoint())
    XCTAssertTrue(delegate.labelPicked)
  }
  
  func testDidSelectFeatureCallsSelectDelegate() {
    let delegate = TestMapSelectDelegate()
    controller.featureSelectDelegate = delegate
    controller.mapView(tgViewController, didSelectFeature: [String : String](), atScreenPosition: CGPoint())
    XCTAssertTrue(delegate.featurePicked)
  }
  
  func testDidSelectMarkerCallsSelectDelegate() {
    let delegate = TestMapSelectDelegate()
    controller.markerSelectDelegate = delegate
    let tgMarker = TGMarker()
    let result = TestTGMarkerPickResult.init(marker: tgMarker)
    controller.currentMarkers[tgMarker] = Marker()
    controller.mapView(tgViewController, didSelectMarker: result, atScreenPosition: CGPoint())
    XCTAssertTrue(delegate.markerPicked)
  }
  
  func testDidSelectLabelDoesNotCallSelectDelegate() {
    let delegate = TestMapSelectDelegate()
    controller.labelSelectDelegate = delegate
    controller.mapView(tgViewController, didSelectLabel: nil, atScreenPosition: CGPoint())
    XCTAssertFalse(delegate.labelPicked)
  }
  
  func testDidSelectFeatureDoesNotSelectDelegate() {
    let delegate = TestMapSelectDelegate()
    controller.featureSelectDelegate = delegate
    controller.mapView(tgViewController, didSelectFeature: nil, atScreenPosition: CGPoint())
    XCTAssertFalse(delegate.featurePicked)
  }
  
  func testDidSelectMarkerDoesNotSelectDelegate() {
    let delegate = TestMapSelectDelegate()
    controller.markerSelectDelegate = delegate
    controller.mapView(tgViewController, didSelectMarker: nil, atScreenPosition: CGPoint())
    XCTAssertFalse(delegate.markerPicked)
  }

  func testAttributionOpensRights() {
    controller.viewDidLoad()
    let actions = controller.attributionBtn.actions(forTarget: controller, forControlEvent: .touchUpInside)
    let selectorStr = actions?.first
    controller.perform(NSSelectorFromString(selectorStr!))
    XCTAssertEqual(testApplication.urlToOpen?.absoluteString, "https://mapzen.com/rights/")
  }

  func testAttributionVisible() {
    let tabVc = UITabBarController.init()
    let vc = MZMapViewController.init()
    tabVc.setViewControllers([vc], animated: false)
    _ = vc.view
    XCTAssertTrue(vc.attributionBtn.frame.origin.y + vc.attributionBtn.frame.size.height < tabVc.tabBar.frame.origin.y)
  }

  func testFindMeVisible() {
    let tabVc = UITabBarController.init()
    let vc = MZMapViewController.init()
    tabVc.setViewControllers([vc], animated: false)
    _ = vc.view
    XCTAssertTrue(vc.findMeButton.frame.origin.y + vc.findMeButton.frame.size.height < tabVc.tabBar.frame.origin.y)
  }

  func testMemoryWarning() {
    controller.tilt = 1.0
    controller.rotation = 2.0
    controller.position = TGGeoPointMake(1.0, 2.0)
    controller.cameraType = .flat
    controller.zoom = 3.0
    controller.currentStyle = .cinnabar
    _ = controller.showCurrentLocation(true)
    controller.findMeButton.isHidden = false
    controller.findMeButton.isEnabled = true
    controller.shouldFollowCurrentLocation = true

    // Normally the OS would call these but can't replicate that easily in tests
    controller.didReceiveMemoryWarning()

    XCTAssertNotNil(controller.stateSaver)
    controller.reloadTGViewController()
    controller.recreateMap(controller.stateSaver!)

    XCTAssertEqualWithAccuracy(controller.tilt, 1.0, accuracy: FLT_EPSILON)
    XCTAssertEqualWithAccuracy(controller.rotation, 2.0, accuracy: FLT_EPSILON)
    //We don't check latitude because of a weird underlying issue with Tangram rounding errors on it. Further investigation required
    XCTAssertEqualWithAccuracy(controller.position.longitude, 1.0, accuracy: DBL_EPSILON)
    XCTAssertEqual(controller.cameraType, .flat)
    XCTAssertEqualWithAccuracy(controller.zoom, 3.0, accuracy: FLT_EPSILON)
    XCTAssertEqual(controller.currentStyle, .cinnabar)
    XCTAssertTrue(controller.shouldShowCurrentLocation)
    XCTAssertFalse(controller.findMeButton.isHidden)
    XCTAssertTrue(controller.findMeButton.isSelected) // Determined by shouldFollowCurrentLocation
    XCTAssertTrue(controller.findMeButton.isEnabled)
  }

  func testAddMarker() {
    let tgMarker = TestTGMarker()
    let marker = Marker(tgMarker: tgMarker)
    controller.addMarker(marker)
    let m = controller.currentMarkers[marker.tgMarker] as! Marker
    XCTAssertEqual(m, marker)
    XCTAssertEqual(marker.tgMarker.map, controller.tgViewController)
  }

  func testRemoveMarker() {
    let tgMarker = TestTGMarker()
    let marker = Marker(tgMarker: tgMarker)
    controller.addMarker(marker)
    controller.removeMarker(marker)
    XCTAssertNil(controller.currentMarkers[marker.tgMarker])
    XCTAssertNil(marker.tgMarker.map)
  }
}

class TestPanDelegate : MapPanGestureDelegate {
  
  var didPanMap = false
  
  func mapController(_ view: MZMapViewController, didPanMap displacement: CGPoint) {
    didPanMap = true
  }
}

class TestPinchDelegate : MapPinchGestureDelegate {
  
  var didPinchMap = false
  
  func mapController(_ view: MZMapViewController, didPinchMap displacement: CGPoint) {
    didPinchMap = true
  }
}

class TestRotateDelegate : MapRotateGestureDelegate {
  
  var didRotateMap = false
  
  func mapController(_ view: MZMapViewController, didRotateMap displacement: CGPoint) {
    didRotateMap = true
  }
}

class TestShoveDelegate : MapShoveGestureDelegate {
  
  var didShoveMap = false
  
  func mapController(_ view: MZMapViewController, didShoveMap displacement: CGPoint) {
    didShoveMap = true
  }
}

class AllEnabledGestureDelegate : MapSingleTapGestureDelegate, MapDoubleTapGestureDelegate, MapLongPressGestureDelegate {
  
  var singleTapReceived = false
  var doubleTapReceived = false
  var longPressTapReceived = false
  
  func mapController(_ view: MZMapViewController, recognizer: UIGestureRecognizer, shouldRecognizeSingleTapGesture location: CGPoint) -> Bool {
    return true
  }
  
  func mapController(_ view: MZMapViewController, recognizer: UIGestureRecognizer, didRecognizeSingleTapGesture location: CGPoint) {
    singleTapReceived = true
  }
  
  func mapController(_ view: MZMapViewController, recognizer: UIGestureRecognizer, shouldRecognizeDoubleTapGesture location: CGPoint) -> Bool {
    return true
  }
  
  func mapController(_ view: MZMapViewController, recognizer: UIGestureRecognizer, didRecognizeDoubleTapGesture location: CGPoint) {
    doubleTapReceived = true
  }
  
  func mapController(_ view: MZMapViewController, recognizer: UIGestureRecognizer, shouldRecognizeLongPressGesture location: CGPoint) -> Bool {
    return true
  }
  
  func mapController(_ view: MZMapViewController, recognizer: UIGestureRecognizer, didRecognizeLongPressGesture location: CGPoint) {
    longPressTapReceived = true
  }
}

class AllDisabledGestureDelegate : MapSingleTapGestureDelegate, MapDoubleTapGestureDelegate, MapLongPressGestureDelegate {
  
  var singleTapReceived = false
  var doubleTapReceived = false
  var longPressTapReceived = false
  
  func mapController(_ view: MZMapViewController, recognizer: UIGestureRecognizer, shouldRecognizeSingleTapGesture location: CGPoint) -> Bool {
    return false
  }
  
  func mapController(_ view: MZMapViewController, recognizer: UIGestureRecognizer, didRecognizeSingleTapGesture location: CGPoint) {
    singleTapReceived = true
  }
  
  func mapController(_ view: MZMapViewController, recognizer: UIGestureRecognizer, shouldRecognizeDoubleTapGesture location: CGPoint) -> Bool {
    return false
  }
  
  func mapController(_ view: MZMapViewController, recognizer: UIGestureRecognizer, didRecognizeDoubleTapGesture location: CGPoint) {
    doubleTapReceived = true
  }
  
  func mapController(_ view: MZMapViewController, recognizer: UIGestureRecognizer, shouldRecognizeLongPressGesture location: CGPoint) -> Bool {
    return false
  }
  
  func mapController(_ view: MZMapViewController, recognizer: UIGestureRecognizer, didRecognizeLongPressGesture location: CGPoint) {
    longPressTapReceived = true
  }
}

class TestLoadDelegate : MapTileLoadDelegate {
  
  var sceneLoaded = false
  var loadingComplete = false
  
  func mapController(_ controller: MZMapViewController, didLoadSceneAsync scene: String) {
    sceneLoaded = true
  }
  
  func mapControllerDidCompleteLoading(_ mapView: MZMapViewController) {
    loadingComplete = true
  }
}

class TestMapSelectDelegate : MapLabelSelectDelegate, MapMarkerSelectDelegate, MapFeatureSelectDelegate {
  
  var labelPicked = false
  var markerPicked = false
  var featurePicked = false
  
  func mapController(_ mapView: MZMapViewController, didSelectLabel labelPickResult: TGLabelPickResult, atScreenPosition position: CGPoint) {
    labelPicked = true
  }
  
  func mapController(_ mapView: MZMapViewController, didSelectMarker marker: GenericMarker, atScreenPosition position: CGPoint) {
    markerPicked = true
  }
  
  func mapController(_ mapView: MZMapViewController, didSelectFeature feature: [String : String], atScreenPosition position: CGPoint) {
    featurePicked = true
  }
}

