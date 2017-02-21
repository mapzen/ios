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
import CoreLocation

class TestMapViewController: MapViewController {
  
  func lastSetPointValue() -> TGGeoPoint? {
    return lastSetPoint
  }
  func currentLocationGemValue() -> TGMapMarkerId? {
    return currentLocationGem
  }
  func shouldShowCurrentLocationValue() -> Bool {
    return shouldShowCurrentLocation
  }
}

class MockHTTPHandler: TGHttpHandler {
  override func downloadRequestAsync(_ url: String!, completionHandler: DownloadCompletionHandler!) {
    //We want Tangram to stay off the network in unit testing, so we no-op this to make certain
  }
}

class MapViewControllerTests: XCTestCase {

  var controller = TestMapViewController()
  var tgViewController = TestTGMapViewController()
  let mockLocation = CLLocation(latitude: 0.0, longitude: 0.0) // Null Island!

  override func setUp() {
    controller.tgViewController = tgViewController
    let mockHTTP = MockHTTPHandler()
    controller.tgViewController.httpHandler = mockHTTP!
  }

  func testInit() {
    XCTAssertNotNil(controller)
    XCTAssertFalse(controller.shouldFollowCurrentLocation)
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

  func testMarkerAdd() {
    controller.markerAdd()
    XCTAssertTrue(tgViewController.addedMarker)
  }
  
  func testMarkerSetStyling() {
    controller.markerSetStyling(8, styling: "styling")
    XCTAssertEqual(tgViewController.currMarkerId, 8)
    XCTAssertEqual(tgViewController.styling, "styling")
  }
  
  func testMarkerSetPoint() {
    let point = TGGeoPoint(longitude: 70.0, latitude: 40.0)
    controller.markerSetPoint(8, coordinates: point)
    XCTAssertEqual(tgViewController.currMarkerId, 8)
    XCTAssertEqual(tgViewController.coordinate.longitude, 70.0)
    XCTAssertEqual(tgViewController.coordinate.latitude, 40.0)
  }
  
  func testMarkerSetPointWithEase() {
    let point = TGGeoPoint(longitude: 70.0, latitude: 40.0)
    controller.markerSetPointEased(8, coordinates: point, duration: 7, easeType: TGEaseType.cubic)
    XCTAssertEqual(tgViewController.currMarkerId, 8)
    XCTAssertEqual(tgViewController.coordinate.longitude, 70.0)
    XCTAssertEqual(tgViewController.coordinate.latitude, 40.0)
    XCTAssertEqual(tgViewController.duration, 7)
    XCTAssertEqual(tgViewController.easeType, TGEaseType.cubic)
  }
  
  func testMarkerSetPolyline() {
    let line = TGGeoPolyline()
    controller.markerSetPolyline(1, polyline: line)
    XCTAssertEqual(tgViewController.currMarkerId, 1)
    XCTAssertEqual(tgViewController.polyline, line)
  }
  
  func testMarkerSetPolygon() {
    let polygon = TGGeoPolygon()
    controller.markerSetPolygon(1, polygon: polygon)
    XCTAssertEqual(tgViewController.currMarkerId, 1)
    XCTAssertEqual(tgViewController.polygon, polygon)
  }
  
  func testMarkerSetVisible() {
    controller.markerSetVisible(2, visible: true)
    XCTAssertEqual(tgViewController.currMarkerId, 2)
    XCTAssertTrue(tgViewController.markerVisible)
  }
  
  func testMarkerSetImage() {
    let image = UIImage()
    controller.markerSetImage(4, image: image)
    XCTAssertEqual(tgViewController.currMarkerId, 4)
    XCTAssertEqual(tgViewController.markerImage, image)
  }
  
  func testMarkerRemove() {
    controller.markerRemove(5)
    XCTAssertEqual(tgViewController.currMarkerId, 5)
  }
  
  func testLoadSceneFile() {
    controller.loadSceneFile("path")
    XCTAssertEqual(tgViewController.scenePath, "path")
  }
  
  func testLoadSceneFileWithUpdates() {
    let updates = [TGSceneUpdate]()
    controller.loadSceneFile("path", sceneUpdates: updates)
    XCTAssertEqual(tgViewController.scenePath, "path")
    XCTAssertEqual(tgViewController.sceneUpdates, updates)
  }
  
  func testLoadSceneFileAsync() {
    controller.loadSceneFileAsync("path")
    XCTAssertEqual(tgViewController.scenePath, "path")
  }

  func testLoadSceneFileAsyncWithUpdates() {
    let updates = [TGSceneUpdate]()
    controller.loadSceneFileAsync("path", sceneUpdates: updates)
    XCTAssertEqual(tgViewController.scenePath, "path")
    XCTAssertEqual(tgViewController.sceneUpdates, updates)
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

  func testLngLatToScreenPosition() {
    let point = TGGeoPointMake(70.0, 40.0)
    controller.lngLat(toScreenPosition: point)
    XCTAssertEqual(tgViewController.lngLatForScreenPosition.longitude, 70.0)
    XCTAssertEqual(tgViewController.lngLatForScreenPosition.latitude, 40.0)
  }

  func testScreenPositionToLngLat() {
    let point = CGPoint(x: 1, y: 2)
    controller.screenPosition(toLngLat: point)
    XCTAssertEqual(tgViewController.screenPositionForLngLat, point)
  }
  
  func testFindMeButtonInitialState() {
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

  func testEnableLocation() {
    controller.enableLocationLayer(true)

    //Tests
    XCTAssertFalse(controller.findMeButton.isHidden)
    XCTAssertTrue(controller.shouldFollowCurrentLocation)
    XCTAssertTrue(controller.shouldShowCurrentLocationValue())
  }

  func testDisableLocation() {
    //Setup
    controller.enableLocationLayer(true)
    controller.enableLocationLayer(false)

    //Tests
    XCTAssertTrue(controller.findMeButton.isHidden)
    XCTAssertFalse(controller.shouldFollowCurrentLocation)
    XCTAssertFalse(controller.shouldShowCurrentLocationValue())
  }

  func testShowCurrentLocation() {
    //Tests
    XCTAssertTrue(controller.showCurrentLocation(true))
    XCTAssertNotNil(controller.currentLocationGemValue())
    XCTAssertTrue(controller.shouldShowCurrentLocationValue())
    XCTAssertTrue(controller.currentLocationGemValue() != 0)
  }

  //MARK: - LocationManagerDelegate Tests
  func testLocationUpdateSansMarkerGeneration() {
    //Setup
    controller.locationDidUpdate(mockLocation)

    //Tests
    XCTAssertNil(controller.lastSetPointValue())
    XCTAssertNil(controller.currentLocationGemValue())
  }

  func testLocationUpdateWithMarkerGeneration() {
    //Setup
    controller.showCurrentLocation(true)
    controller.locationDidUpdate(mockLocation)

    //Tests
    XCTAssertNotNil(controller.lastSetPointValue())
    XCTAssertTrue(controller.lastSetPointValue()?.latitude == mockLocation.coordinate.latitude)
    XCTAssertTrue(controller.lastSetPointValue()?.longitude == mockLocation.coordinate.longitude)
  }

  func testAddAnnotations(){
    let testAnno1 = PeliasMapkitAnnotation(coordinate: CLLocationCoordinate2DMake(0.0, 0.0), title: "Test1", subtitle: "SubTest1", data: nil)
    let testAnno2 = PeliasMapkitAnnotation(coordinate: CLLocationCoordinate2DMake(1.0, 1.0), title: "Test2", subtitle: "SubTest2", data: nil)
    let controller = MapViewController() // Grab local instance cuz we don't want to use mocks for these
    let _ = try? controller.add([testAnno1, testAnno2])

    //Tests
    XCTAssertNotNil(controller.currentAnnotations[testAnno1])
    XCTAssertNotNil(controller.currentAnnotations[testAnno2])

  }

  func testRemoveSingleAnnotation(){
    let testAnno1 = PeliasMapkitAnnotation(coordinate: CLLocationCoordinate2DMake(0.0, 0.0), title: "Test1", subtitle: "SubTest1", data: nil)
    let controller = MapViewController() // Grab local instance cuz we don't want to use mocks for these
    let _ = try? controller.add([testAnno1])

    //Tests
    let _ = try? controller.remove(testAnno1)
    XCTAssertNil(controller.currentAnnotations[testAnno1])

  }

  func testRemoveAllAnnotations(){
    let testAnno1 = PeliasMapkitAnnotation(coordinate: CLLocationCoordinate2DMake(0.0, 0.0), title: "Test1", subtitle: "SubTest1", data: nil)
    let testAnno2 = PeliasMapkitAnnotation(coordinate: CLLocationCoordinate2DMake(1.0, 1.0), title: "Test2", subtitle: "SubTest2", data: nil)
    let controller = MapViewController() // Grab local instance cuz we don't want to use mocks for these
    let _ = try? controller.add([testAnno1, testAnno2])

    //Tests
    let _ = try? controller.removeAnnotations()
    XCTAssertNil(controller.currentAnnotations[testAnno1])
    XCTAssertNil(controller.currentAnnotations[testAnno2])
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
    controller.gestureDelegate = delegate
    controller.mapView(controller.tgViewController, recognizer: UIGestureRecognizer(), didRecognizeSingleTapGesture: CGPoint())
    XCTAssertTrue(delegate.singleTapReceived)
  }
  
  func testDoubleTapRecognizedShouldCallDelegate() {
    let delegate = AllEnabledGestureDelegate()
    controller.gestureDelegate = delegate
    controller.mapView(controller.tgViewController, recognizer: UIGestureRecognizer(), didRecognizeDoubleTapGesture: CGPoint())
    XCTAssertTrue(delegate.doubleTapReceived)
  }
  
  func testLongPressRecognizedShouldCallDelegate() {
    let delegate = AllEnabledGestureDelegate()
    controller.gestureDelegate = delegate
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
  
  func testSingleTapRecognizedPicksLabel() {
    controller.mapView(controller.tgViewController, recognizer: UIGestureRecognizer(), didRecognizeSingleTapGesture: CGPoint(x: 30, y: 40))
    XCTAssertEqual(tgViewController.labelPickPosition.x, 30)
    XCTAssertEqual(tgViewController.labelPickPosition.y, 40)
  }
  
  func testSingleTapRecognizedPicksMarker() {
    controller.mapView(controller.tgViewController, recognizer: UIGestureRecognizer(), didRecognizeSingleTapGesture: CGPoint(x: 30, y: 40))
    XCTAssertEqual(tgViewController.markerPickPosition.x, 30)
    XCTAssertEqual(tgViewController.markerPickPosition.y, 40)
  }
  
  func testSingleTapRecognizedPicksFeature() {
    controller.mapView(controller.tgViewController, recognizer: UIGestureRecognizer(), didRecognizeSingleTapGesture: CGPoint(x: 30, y: 40))
    XCTAssertEqual(tgViewController.featurePickPosition.x, 30)
    XCTAssertEqual(tgViewController.featurePickPosition.y, 40)
  }
  
  func testShouldNotRecognizeSingleTapPicksLabel() {
    let delegate = AllDisabledGestureDelegate()
    controller.gestureDelegate = delegate
    let _ = controller.mapView(controller.tgViewController, recognizer: UIGestureRecognizer(), shouldRecognizeSingleTapGesture: CGPoint(x: 30, y: 40))
    XCTAssertEqual(tgViewController.labelPickPosition.x, 30)
    XCTAssertEqual(tgViewController.labelPickPosition.y, 40)
  }
  
  func testShouldNotRecognizePicksMarker() {
    let delegate = AllDisabledGestureDelegate()
    controller.gestureDelegate = delegate
    let _ = controller.mapView(controller.tgViewController, recognizer: UIGestureRecognizer(), shouldRecognizeSingleTapGesture: CGPoint(x: 30, y: 40))
    XCTAssertEqual(tgViewController.markerPickPosition.x, 30)
    XCTAssertEqual(tgViewController.markerPickPosition.y, 40)
  }
  
  func testShouldNotRecognizePicksFeature() {
    let delegate = AllDisabledGestureDelegate()
    controller.gestureDelegate = delegate
    let _ = controller.mapView(controller.tgViewController, recognizer: UIGestureRecognizer(), shouldRecognizeSingleTapGesture: CGPoint(x: 30, y: 40))
    XCTAssertEqual(tgViewController.featurePickPosition.x, 30)
    XCTAssertEqual(tgViewController.featurePickPosition.y, 40)
  }
  
  func testLoadSceneAsyncCallsLoadDelegate() {
    let delegate = TestLoadDelegate()
    controller.loadDelegate = delegate
    controller.mapView(controller.tgViewController, didLoadSceneAsync: "scene")
    XCTAssertTrue(delegate.sceneLoaded)
  }
  
  func testDidCompleteLoadingCallsLoadDelegate() {
    let delegate = TestLoadDelegate()
    controller.loadDelegate = delegate
    controller.mapViewDidCompleteLoading(controller.tgViewController)
    XCTAssertTrue(delegate.loadingComplete)
  }
  
  func testDidSelectLabelCallsSelectDelegate() {
    let delegate = TestMapSelectDelegate()
    controller.selectDelegate = delegate
    controller.mapView(tgViewController, didSelectLabel: nil, atScreenPosition: CGPoint())
    XCTAssertTrue(delegate.labelPicked)
  }
  
  func testDidSelectFeatureCallsSelectDelegate() {
    let delegate = TestMapSelectDelegate()
    controller.selectDelegate = delegate
    controller.mapView(tgViewController, didSelectFeature: nil, atScreenPosition: CGPoint())
    XCTAssertTrue(delegate.featurePicked)
  }
  
  func testDidSelectMarkerCallsSelectDelegate() {
    let delegate = TestMapSelectDelegate()
    controller.selectDelegate = delegate
    controller.mapView(tgViewController, didSelectMarker: nil, atScreenPosition: CGPoint())
    XCTAssertTrue(delegate.markerPicked)
  }
}

class TestPanDelegate : NSObject, MapPanGestureDelegate {
  
  var didPanMap = false
  
  func mapController(_ view: MapViewController, didPanMap displacement: CGPoint) {
    didPanMap = true
  }
}

class TestPinchDelegate : NSObject, MapPinchGestureDelegate {
  
  var didPinchMap = false
  
  func mapController(_ view: MapViewController, didPinchMap displacement: CGPoint) {
    didPinchMap = true
  }
}

class TestRotateDelegate : NSObject, MapRotateGestureDelegate {
  
  var didRotateMap = false
  
  func mapController(_ view: MapViewController, didRotateMap displacement: CGPoint) {
    didRotateMap = true
  }
}

class TestShoveDelegate : NSObject, MapShoveGestureDelegate {
  
  var didShoveMap = false
  
  func mapController(_ view: MapViewController, didShoveMap displacement: CGPoint) {
    didShoveMap = true
  }
}

class AllEnabledGestureDelegate : NSObject, MapGestureDelegate {
  
  var singleTapReceived = false
  var doubleTapReceived = false
  var longPressTapReceived = false
  
  func mapController(_ view: MapViewController, recognizer: UIGestureRecognizer, shouldRecognizeSingleTapGesture location: CGPoint) -> Bool {
    return true
  }
  
  func mapController(_ view: MapViewController, recognizer: UIGestureRecognizer, didRecognizeSingleTapGesture location: CGPoint) {
    singleTapReceived = true
  }
  
  func mapController(_ view: MapViewController, recognizer: UIGestureRecognizer, shouldRecognizeDoubleTapGesture location: CGPoint) -> Bool {
    return true
  }
  
  func mapController(_ view: MapViewController, recognizer: UIGestureRecognizer, didRecognizeDoubleTapGesture location: CGPoint) {
    doubleTapReceived = true
  }
  
  func mapController(_ view: MapViewController, recognizer: UIGestureRecognizer, shouldRecognizeLongPressGesture location: CGPoint) -> Bool {
    return true
  }
  
  func mapController(_ view: MapViewController, recognizer: UIGestureRecognizer, didRecognizeLongPressGesture location: CGPoint) {
    longPressTapReceived = true
  }
}

class AllDisabledGestureDelegate : NSObject, MapGestureDelegate {
  
  var singleTapReceived = false
  var doubleTapReceived = false
  var longPressTapReceived = false
  
  func mapController(_ view: MapViewController, recognizer: UIGestureRecognizer, shouldRecognizeSingleTapGesture location: CGPoint) -> Bool {
    return false
  }
  
  func mapController(_ view: MapViewController, recognizer: UIGestureRecognizer, didRecognizeSingleTapGesture location: CGPoint) {
    singleTapReceived = true
  }
  
  func mapController(_ view: MapViewController, recognizer: UIGestureRecognizer, shouldRecognizeDoubleTapGesture location: CGPoint) -> Bool {
    return false
  }
  
  func mapController(_ view: MapViewController, recognizer: UIGestureRecognizer, didRecognizeDoubleTapGesture location: CGPoint) {
    doubleTapReceived = true
  }
  
  func mapController(_ view: MapViewController, recognizer: UIGestureRecognizer, shouldRecognizeLongPressGesture location: CGPoint) -> Bool {
    return false
  }
  
  func mapController(_ view: MapViewController, recognizer: UIGestureRecognizer, didRecognizeLongPressGesture location: CGPoint) {
    longPressTapReceived = true
  }
}

class TestLoadDelegate : NSObject, MapLoadDelegate {
  
  var sceneLoaded = false
  var loadingComplete = false
  
  func mapController(_ controller: MapViewController, didLoadSceneAsync scene: String) {
    sceneLoaded = true
  }
  
  func mapControllerDidCompleteLoading(_ mapView: MapViewController) {
    loadingComplete = true
  }
}

class TestMapSelectDelegate : NSObject, MapSelectDelegate {
  
  var labelPicked = false
  var markerPicked = false
  var featurePicked = false
  
  func mapController(_ mapView: MapViewController, didSelectLabel labelPickResult: TGLabelPickResult?, atScreenPosition position: CGPoint) {
    labelPicked = true
  }
  
  func mapController(_ mapView: MapViewController, didSelectMarker markerPickResult: TGMarkerPickResult?, atScreenPosition position: CGPoint) {
    markerPicked = true
  }
  
  func mapController(_ mapView: MapViewController, didSelectFeature feature: [AnyHashable : Any]?, atScreenPosition position: CGPoint) {
    featurePicked = true
  }
}

