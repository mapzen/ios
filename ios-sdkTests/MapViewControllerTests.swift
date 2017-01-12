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
  override func markerAdd() -> TGMapMarkerId {
    //Mocked out to always return a valid ID
    return 1
  }
}

class MockHTTPHandler: TGHttpHandler {
  override func downloadRequestAsync(url: String!, completionHandler: DownloadCompletionHandler!) {
    //We want Tangram to stay off the network in unit testing, so we no-op this to make certain
  }
}

class MapViewControllerTests: XCTestCase {

  var controller = TestMapViewController()
  let mockLocation = CLLocation(latitude: 0.0, longitude: 0.0) // Null Island!

  override func setUp() {
    controller = TestMapViewController()
    let mockHTTP = MockHTTPHandler()
    controller.httpHandler = mockHTTP
  }

  func testInit() {
    XCTAssertNotNil(controller)
    XCTAssertFalse(controller.shouldFollowCurrentLocation)
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

  //TODO: Enable these once https://github.com/tangrams/tangram-es/issues/1220 gets resolved

//  func testAddAnnotations(){
//    let testAnno1 = PeliasMapkitAnnotation(coordinate: CLLocationCoordinate2DMake(0.0, 0.0), title: "Test1", subtitle: "SubTest1", data: nil)
//    let testAnno2 = PeliasMapkitAnnotation(coordinate: CLLocationCoordinate2DMake(1.0, 1.0), title: "Test2", subtitle: "SubTest2", data: nil)
//    let controller = MapViewController() // Grab local instance cuz we don't want to use mocks for these
//    let _ = try? controller.add([testAnno1, testAnno2])
//
//    //Tests
//    XCTAssertNotNil(controller.currentAnnotations[testAnno1])
//    XCTAssertNotNil(controller.currentAnnotations[testAnno2])
//
//  }
//
//  func testRemoveSingleAnnotation(){
//    let testAnno1 = PeliasMapkitAnnotation(coordinate: CLLocationCoordinate2DMake(0.0, 0.0), title: "Test1", subtitle: "SubTest1", data: nil)
//    let controller = MapViewController() // Grab local instance cuz we don't want to use mocks for these
//    let _ = try? controller.add([testAnno1])
//
//    //Tests
//    let _ = try? controller.remove(testAnno1)
//    XCTAssertNil(controller.currentAnnotations[testAnno1])
//
//  }
//
//  func testRemoveAllAnnotations(){
//    let testAnno1 = PeliasMapkitAnnotation(coordinate: CLLocationCoordinate2DMake(0.0, 0.0), title: "Test1", subtitle: "SubTest1", data: nil)
//    let testAnno2 = PeliasMapkitAnnotation(coordinate: CLLocationCoordinate2DMake(1.0, 1.0), title: "Test2", subtitle: "SubTest2", data: nil)
//    let controller = MapViewController() // Grab local instance cuz we don't want to use mocks for these
//    let _ = try? controller.add([testAnno1, testAnno2])
//
//    //Tests
//    let _ = try? controller.removeAnnotations()
//    XCTAssertNil(controller.currentAnnotations[testAnno1])
//    XCTAssertNil(controller.currentAnnotations[testAnno2])
//  }

}
