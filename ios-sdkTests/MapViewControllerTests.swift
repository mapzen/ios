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
  override func downloadRequestAsync(url: String!, completionHandler: DownloadCompletionHandler!) {
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
    controller.tgViewController.httpHandler = mockHTTP
  }

  func testInit() {
    XCTAssertNotNil(controller)
    XCTAssertFalse(controller.shouldFollowCurrentLocation)
  }
  
  func testAnimateToPosition() {
    let point = TGGeoPoint(longitude: 70.0, latitude: 40.0)
    controller.animateToPosition(point, withDuration: 3)
    XCTAssertEqual(tgViewController.coordinate.longitude, 70.0)
    XCTAssertEqual(tgViewController.coordinate.latitude, 40.0)
    XCTAssertEqual(tgViewController.duration, 3)
  }
  
  func testAnimateToPositionWithEase() {
    let point = TGGeoPoint(longitude: 70.0, latitude: 40.0)
    controller.animateToPosition(point, withDuration: 3, withEaseType: TGEaseType.Cubic)
    XCTAssertEqual(tgViewController.coordinate.longitude, 70.0)
    XCTAssertEqual(tgViewController.coordinate.latitude, 40.0)
    XCTAssertEqual(tgViewController.duration, 3)
    XCTAssertEqual(tgViewController.easeType, TGEaseType.Cubic)
  }

  func testAnimateToZoom() {
    controller.animateToZoomLevel(1.0, withDuration: 2.0)
    XCTAssertEqual(tgViewController.zoom, 1.0)
    XCTAssertEqual(tgViewController.duration, 2.0)
  }

  func testAnimateToZoomWithEase() {
    controller.animateToZoomLevel(1.0, withDuration: 2.0, withEaseType: TGEaseType.Cubic)
    XCTAssertEqual(tgViewController.zoom, 1.0)
    XCTAssertEqual(tgViewController.duration, 2.0)
    XCTAssertEqual(tgViewController.easeType, TGEaseType.Cubic)
  }
  
  func testAnimateToRotation() {
    controller.animateToRotation(1.0, withDuration: 9.0)
    XCTAssertEqual(tgViewController.rotation, 1.0)
    XCTAssertEqual(tgViewController.duration, 9.0)
  }
  
  func testAnimateToRotationWithEase() {
    controller.animateToRotation(1.0, withDuration: 9.0, withEaseType: TGEaseType.Linear)
    XCTAssertEqual(tgViewController.rotation, 1.0)
    XCTAssertEqual(tgViewController.duration, 9.0)
    XCTAssertEqual(tgViewController.easeType, TGEaseType.Linear)
  }
  
  func testAnimateToTilt() {
    controller.animateToTilt(3.0, withDuration: 4.0)
    XCTAssertEqual(tgViewController.tilt, 3.0)
    XCTAssertEqual(tgViewController.duration, 4.0)
  }
  
  func testAnimateToTiltWithEase() {
    controller.animateToTilt(3.0, withDuration: 4.0, withEaseType: TGEaseType.Sine)
    XCTAssertEqual(tgViewController.tilt, 3.0)
    XCTAssertEqual(tgViewController.duration, 4.0)
    XCTAssertEqual(tgViewController.easeType, TGEaseType.Sine)
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
    controller.markerSetPointEased(8, coordinates: point, duration: 7, easeType: TGEaseType.Cubic)
    XCTAssertEqual(tgViewController.currMarkerId, 8)
    XCTAssertEqual(tgViewController.coordinate.longitude, 70.0)
    XCTAssertEqual(tgViewController.coordinate.latitude, 40.0)
    XCTAssertEqual(tgViewController.duration, 7)
    XCTAssertEqual(tgViewController.easeType, TGEaseType.Cubic)
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
    controller.queueSceneUpdates(updates)
    XCTAssertEqual(tgViewController.sceneUpdates, updates)
    
  }
  
  func testApplySceneUpdates() {
    controller.applySceneUpdates()
    XCTAssertTrue(tgViewController.appliedSceneUpdates)
  }

  func testLngLatToScreenPosition() {
    let point = TGGeoPointMake(70.0, 40.0)
    controller.lngLatToScreenPosition(point)
    XCTAssertEqual(tgViewController.lngLatForScreenPosition.longitude, 70.0)
    XCTAssertEqual(tgViewController.lngLatForScreenPosition.latitude, 40.0)
  }

  func testScreenPositionToLngLat() {
    let point = CGPointMake(1, 2)
    controller.screenPositionToLngLat(point)
    XCTAssertEqual(tgViewController.screenPositionForLngLat, point)
  }
  
  func testFindMeButtonInitialState() {
    //Test Initial State
    XCTAssertTrue(controller.findMeButton.hidden)
    XCTAssertFalse(controller.findMeButton.enabled)
    XCTAssertFalse(controller.findMeButton.adjustsImageWhenHighlighted)
  }

  func testShowFindMeButton() {
    //Setup
    controller.showFindMeButon(true)

    //Tests
    XCTAssertFalse(controller.findMeButton.hidden)
    XCTAssertTrue(controller.findMeButton.enabled)

    //Now for flipping it back to false
    controller.showFindMeButon(false)

    //Tests
    XCTAssertTrue(controller.findMeButton.hidden)
    XCTAssertFalse(controller.findMeButton.enabled)
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
    XCTAssertFalse(controller.findMeButton.hidden)
    XCTAssertTrue(controller.shouldFollowCurrentLocation)
    XCTAssertTrue(controller.shouldShowCurrentLocationValue())
  }

  func testDisableLocation() {
    //Setup
    controller.enableLocationLayer(true)
    controller.enableLocationLayer(false)

    //Tests
    XCTAssertTrue(controller.findMeButton.hidden)
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

}
