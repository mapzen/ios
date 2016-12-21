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

class MapViewControllerTests: XCTestCase {

    var controller = MapViewController()

    override func setUp() {
        controller = MapViewController()
    }

    func testInit() {
        XCTAssertNotNil(controller)
    }

    func testFindMeButtonInitialState() {
        //Test Initial State
        XCTAssert(controller.findMeButton.hidden == true)
        XCTAssert(controller.findMeButton.enabled == false)
    }

    func testShowFindMeButton() {
        //Setup
        controller.showFindMeButon(true)

        //Tests
        XCTAssert(controller.findMeButton.hidden == false)
        XCTAssert(controller.findMeButton.enabled == true)

        //Now for flipping it back to false
        controller.showFindMeButon(false)

        //Tests
        XCTAssert(controller.findMeButton.hidden == true)
        XCTAssert(controller.findMeButton.enabled == false)
    }

    func testDisableLocation() {
        //Setup
        controller.shouldFollowCurrentLocation = true
        controller.showFindMeButon(true)

        //Tests
        controller.enableLocationLayer(false)
        XCTAssert(controller.shouldFollowCurrentLocation == false)
        XCTAssert(controller.findMeButton.hidden == true)
    }
}
