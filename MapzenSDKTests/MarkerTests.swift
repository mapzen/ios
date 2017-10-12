//
//  MarkerTests.swift
//  ios-sdk
//
//  Created by Sarah Lensing on 3/22/17.
//  Copyright © 2017 Mapzen. All rights reserved.
//

import XCTest
@testable import MapzenSDK
import TangramMap

class PointMarkerTests: XCTestCase {

  var marker = PointMarker()
  let mapVC = TestMapViewController()

  override func setUp() {
    super.setUp()
    mapVC.markerRemoveAll()
    marker = PointMarker()
    mapVC.addMarker(marker)
  }

  func testPoint() {
    let point = TGGeoPoint(longitude: 70.0, latitude: 40.0)
    marker.point = point
    XCTAssertEqual(marker.point.latitude, point.latitude)
    XCTAssertEqual(marker.point.longitude, point.longitude)
    XCTAssertEqual(marker.tgMarker?.point.latitude, point.latitude)
    XCTAssertEqual(marker.tgMarker?.point.longitude, point.longitude)
    marker.size = .zero
    XCTAssertTrue((marker.tgMarker?.stylingString.contains("style: 'points'"))!)
    XCTAssertTrue((marker.tgMarker?.stylingString.contains("size:"))!)
  }

  //TODO: failing, fix
//  func testIcon() {
//    let icon = UIImage(named: "ic_find_me_normal")
//    let map = MapViewController()
//    _ = map.view
//    try? map.loadStyle(.bubbleWrap)
//    map.addMarker(marker)
//    marker.icon = icon
//    XCTAssertEqual(marker.icon, icon)
//    XCTAssertEqual(marker.tgMarker.icon, icon)
//    XCTAssertTrue(marker.tgMarker.stylingString.contains("style: 'points'"))
//    XCTAssertEqual(marker.size, icon?.size)
//    XCTAssertTrue(marker.tgMarker.stylingString.contains("size: [\(icon?.size.width)px, \(icon?.size.height)px]"))
//  }

  func testVisible() {
    XCTAssertTrue(marker.visible)
    XCTAssertTrue((marker.tgMarker?.visible)!)
    marker.visible = false
    XCTAssertFalse(marker.visible)
    XCTAssertFalse((marker.tgMarker?.visible)!)
  }

  func testDrawOrder() {
    XCTAssertEqual(marker.drawOrder, 0)
    XCTAssertEqual(marker.tgMarker?.drawOrder, 0)
    marker.drawOrder = 8
    XCTAssertEqual(marker.drawOrder, 8)
    XCTAssertEqual(marker.tgMarker?.drawOrder, 8)
  }

  func testSize() {
    XCTAssertEqual(marker.size, CGSize.zero)
    let size = CGSize(width: 8, height: 8)
    marker.size = size
    XCTAssertEqual(marker.size, size)
    XCTAssertTrue((marker.tgMarker?.stylingString.contains("size: [\(size.width)px, \(size.height)px]"))!)
  }

  func testBackgroundColor() {
    XCTAssertEqual(marker.backgroundColor, UIColor.white)
    let bgColor = UIColor.red
    marker.backgroundColor = bgColor
    let hex = bgColor.hexValue()
    XCTAssertEqual(marker.backgroundColor, bgColor)
    XCTAssertTrue((marker.tgMarker?.stylingString.contains("color: '\(hex)'"))!)
  }

  func testInteractive() {
    XCTAssertTrue(marker.interactive)
    marker.interactive = false
    XCTAssertFalse(marker.interactive)
    XCTAssertTrue((marker.tgMarker?.stylingString.contains("interactive: false"))!)
  }

  func testInitWithSize() {
    let size = CGSize(width: 30, height: 30)
    let m = PointMarker.init(size: size)
    mapVC.addMarker(m)
    XCTAssertEqual(m.size, size)
    XCTAssertEqual(m.backgroundColor, UIColor.white)
    XCTAssertTrue(m.interactive)
    XCTAssertTrue((m.tgMarker?.stylingString.contains("size: [\(size.width)px, \(size.height)px]"))!)
  }

  func testInit() {
    let m = PointMarker.init()
    XCTAssertEqual(m.backgroundColor, UIColor.white)
    XCTAssertTrue(m.interactive)
    XCTAssertFalse((m.tgMarker?.stylingString.contains("size:")) ?? false )
  }
  
//  func testInitWithIcon() {
//    let image = UIImage(named: "ic_find_me_normal")
//    let m = Marker.init(icon: image)
//    XCTAssertEqual(m.size, image?.size)
//    XCTAssertEqual(m.backgroundColor, UIColor.white)
//    XCTAssertTrue(m.interactive)
//    XCTAssertEqual(m.icon, image)
//  }

  func testSetPointEased() {
    let point = TGGeoPoint(longitude: 70.0, latitude: 40.0)
    let tgMarker = TestTGMarker()
    let m = PointMarker(tgMarker: tgMarker)
    _ = m.setPointEased(point, seconds: 4, easeType: .linear)
    XCTAssertEqual(tgMarker.coordinates.latitude, 40.0)
    XCTAssertEqual(tgMarker.coordinates.longitude, 70.0)
    XCTAssertEqual(tgMarker.seconds, 4)
    XCTAssertEqual(tgMarker.ease, .linear)
  }
}

class PolylineMarkerTests: XCTestCase {

  var marker = PolylineMarker()
  let mapVC = TestMapViewController()

  override func setUp() {
    super.setUp()
    mapVC.markerRemoveAll()
    marker = PolylineMarker()
    mapVC.addMarker(marker)
  }

  func testPolyline() {
    let polyline = TGGeoPolyline()
    marker.polyline = polyline
    XCTAssertEqual(marker.polyline, polyline)
    XCTAssertEqual(marker.tgMarker?.polyline, polyline)
    XCTAssertTrue((marker.tgMarker?.stylingString.contains("style: 'lines'"))!)
    XCTAssertFalse((marker.tgMarker?.stylingString.contains("size:"))!)
  }

  func testVisible() {
    XCTAssertTrue(marker.visible)
    XCTAssertTrue((marker.tgMarker?.visible)!)
    marker.visible = false
    XCTAssertFalse(marker.visible)
    XCTAssertFalse((marker.tgMarker?.visible)!)
  }

  func testDrawOrder() {
    XCTAssertEqual(marker.drawOrder, 0)
    XCTAssertEqual(marker.tgMarker?.drawOrder, 0)
    marker.drawOrder = 8
    XCTAssertEqual(marker.drawOrder, 8)
    XCTAssertEqual(marker.tgMarker?.drawOrder, 8)
  }

  func testInteractive() {
    XCTAssertTrue(marker.interactive)
    marker.interactive = false
    XCTAssertFalse(marker.interactive)
    XCTAssertTrue((marker.tgMarker?.stylingString.contains("interactive: false"))!)
  }

  func testOrder() {
    XCTAssertEqual(marker.order, 1000)
    marker.order = 8
    XCTAssertEqual(marker.order, 8)
    XCTAssertTrue((marker.tgMarker?.stylingString.contains("order: 8"))!)
  }

  func testStrokeWidth() {
    XCTAssertEqual(marker.strokeWidth, 10)
    marker.strokeWidth = 8
    XCTAssertEqual(marker.strokeWidth, 8)
    XCTAssertTrue((marker.tgMarker?.stylingString.contains("width: 8"))!)
  }
}

class PolygonMarkerTests: XCTestCase {

  var marker = PolygonMarker()
  let mapVC = TestMapViewController()

  override func setUp() {
    super.setUp()
    mapVC.markerRemoveAll()
    marker = PolygonMarker()
    mapVC.addMarker(marker)
  }

  func testPolygon() {
    let polygon = TGGeoPolygon()
    marker.polygon = polygon
    XCTAssertEqual(marker.polygon, polygon)
    XCTAssertEqual(marker.tgMarker?.polygon, polygon)
    XCTAssertTrue((marker.tgMarker?.stylingString.contains("style: 'polygons'"))!)
    XCTAssertFalse((marker.tgMarker?.stylingString.contains("size:"))!)
  }

  func testVisible() {
    XCTAssertTrue(marker.visible)
    XCTAssertTrue((marker.tgMarker?.visible)!)
    marker.visible = false
    XCTAssertFalse(marker.visible)
    XCTAssertFalse((marker.tgMarker?.visible)!)
  }

  func testDrawOrder() {
    XCTAssertEqual(marker.drawOrder, 0)
    XCTAssertEqual(marker.tgMarker?.drawOrder, 0)
    marker.drawOrder = 8
    XCTAssertEqual(marker.drawOrder, 8)
    XCTAssertEqual(marker.tgMarker?.drawOrder, 8)
  }

  func testInteractive() {
    XCTAssertTrue(marker.interactive)
    marker.interactive = false
    XCTAssertFalse(marker.interactive)
    XCTAssertTrue((marker.tgMarker?.stylingString.contains("interactive: false"))!)
  }

  func testOrder() {
    XCTAssertEqual(marker.order, 1000)
    marker.order = 8
    XCTAssertEqual(marker.order, 8)
    XCTAssertTrue((marker.tgMarker?.stylingString.contains("order: 8"))!)
  }
}

class SystemPointMarkerTests: XCTestCase {

  var marker = SystemPointMarker(markerType: .currentLocation)
  let mapVC = TestMapViewController()

  override func setUp() {
    super.setUp()
    mapVC.markerRemoveAll()
    marker = SystemPointMarker(markerType: .currentLocation)
    mapVC.addMarker(marker)
  }

  func testTypeCurrentLocation() {
    XCTAssertEqual(marker.tgMarker?.stylingPath, "layers.mz_current_location_gem.draw.ux-location-gem-overlay")
    XCTAssertTrue((marker.tgMarker?.stylingString.isEmpty)!)
  }

  func testTypeRouteLocation() {
    let m = SystemPointMarker.initWithMarkerType(.routeLocation)
    mapVC.addMarker(m)
    XCTAssertEqual(m.tgMarker?.stylingPath, "layers.mz_route_location.draw.ux-location-gem-overlay")
    XCTAssertTrue((m.tgMarker?.stylingString.isEmpty)!)
  }

  func testTypeDroppedPin() {
    let m = SystemPointMarker.initWithMarkerType(.droppedPin)
    mapVC.addMarker(m)
    XCTAssertEqual(m.tgMarker?.stylingPath, "layers.mz_dropped_pin.draw.ux-icons-overlay")
    XCTAssertTrue((m.tgMarker?.stylingString.isEmpty)!)
  }
  
  func testVisible() {
    XCTAssertTrue(marker.visible)
    XCTAssertTrue((marker.tgMarker?.visible)!)
    marker.visible = false
    XCTAssertFalse(marker.visible)
    XCTAssertFalse((marker.tgMarker?.visible)!)
  }

  func testDrawOrder() {
    XCTAssertEqual(marker.drawOrder, 0)
    XCTAssertEqual(marker.tgMarker?.drawOrder, 0)
    marker.drawOrder = 8
    XCTAssertEqual(marker.drawOrder, 8)
    XCTAssertEqual(marker.tgMarker?.drawOrder, 8)
  }

  func testPoint() {
    let point = TGGeoPoint(longitude: 70.0, latitude: 40.0)
    marker.point = point
    XCTAssertEqual(marker.point.latitude, point.latitude)
    XCTAssertEqual(marker.point.longitude, point.longitude)
    XCTAssertEqual(marker.tgMarker?.point.latitude, point.latitude)
    XCTAssertEqual(marker.tgMarker?.point.longitude, point.longitude)
  }
  
  func testSetPointEased() {
    let point = TGGeoPoint(longitude: 70.0, latitude: 40.0)
    let tgMarker = TestTGMarker()
    let m = PointMarker(tgMarker: tgMarker)
    _ = m.setPointEased(point, seconds: 4, easeType: .linear)
    XCTAssertEqual(tgMarker.coordinates.latitude, 40.0)
    XCTAssertEqual(tgMarker.coordinates.longitude, 70.0)
    XCTAssertEqual(tgMarker.seconds, 4)
    XCTAssertEqual(tgMarker.ease, .linear)
  }

}

class SelectableSystemPointMarkerTests: XCTestCase {

  var marker = SelectableSystemPointMarker(markerType: .routeStart)
  let mapVC = TestMapViewController()

  override func setUp() {
    super.setUp()
    mapVC.markerRemoveAll()
    marker = SelectableSystemPointMarker(markerType: .routeStart)
    mapVC.addMarker(marker)
  }

  func testTypeRouteStart() {
    XCTAssertEqual(marker.tgMarker?.stylingPath, "layers.mz_route_start.draw.ux-icons-overlay")
    XCTAssertTrue((marker.tgMarker?.stylingString.isEmpty)!)
  }

  func testTypeRouteDestination() {
    let m = SelectableSystemPointMarker.initWithMarkerType(.routeDestination)
    mapVC.addMarker(m)
    XCTAssertEqual(m.tgMarker?.stylingPath, "layers.mz_route_destination.draw.ux-icons-overlay")
    XCTAssertTrue((m.tgMarker?.stylingString.isEmpty)!)
  }

  func testTypeSearchPin() {
    let m = SelectableSystemPointMarker.initWithMarkerType(.searchPin)
    mapVC.addMarker(m)
    XCTAssertEqual(m.tgMarker?.stylingPath, "layers.mz_search_result.draw.ux-icons-overlay")
    XCTAssertTrue((m.tgMarker?.stylingString.isEmpty)!)
  }

  func testTypeRouteStartInactive() {
    marker.active = false
    // there is no inactive draw rule for route start so its same as active state
    XCTAssertEqual(marker.tgMarker?.stylingPath, "layers.mz_route_start.draw.ux-icons-overlay")
    XCTAssertTrue((marker.tgMarker?.stylingString.isEmpty)!)
  }

  func testTypeRouteDestinationInactive() {
    let m = SelectableSystemPointMarker.initWithMarkerType(.routeDestination)
    mapVC.addMarker(m)
    marker.active = false
    // there is no inactive draw rule for route start so its same as active state
    XCTAssertEqual(m.tgMarker?.stylingPath, "layers.mz_route_destination.draw.ux-icons-overlay")
    XCTAssertTrue((m.tgMarker?.stylingString.isEmpty)!)
  }
  func testTypeSearchPinInactive() {
    let m = SelectableSystemPointMarker.initWithMarkerType(.searchPin)
    mapVC.addMarker(m)
    m.active = false
    XCTAssertEqual(m.tgMarker?.stylingPath, "layers.mz_search_result.inactive.draw.ux-icons-overlay")
    XCTAssertTrue((m.tgMarker?.stylingString.isEmpty)!)
  }

  func testVisible() {
    XCTAssertTrue(marker.visible)
    XCTAssertTrue((marker.tgMarker?.visible)!)
    marker.visible = false
    XCTAssertFalse(marker.visible)
    XCTAssertFalse((marker.tgMarker?.visible)!)
  }

  func testDrawOrder() {
    XCTAssertEqual(marker.drawOrder, 0)
    XCTAssertEqual(marker.tgMarker?.drawOrder, 0)
    marker.drawOrder = 8
    XCTAssertEqual(marker.drawOrder, 8)
    XCTAssertEqual(marker.tgMarker?.drawOrder, 8)
  }

  func testPoint() {
    let point = TGGeoPoint(longitude: 70.0, latitude: 40.0)
    marker.point = point
    XCTAssertEqual(marker.point.latitude, point.latitude)
    XCTAssertEqual(marker.point.longitude, point.longitude)
    XCTAssertEqual(marker.tgMarker?.point.latitude, point.latitude)
    XCTAssertEqual(marker.tgMarker?.point.longitude, point.longitude)
  }

  func testSetPointEased() {
    let point = TGGeoPoint(longitude: 70.0, latitude: 40.0)
    let tgMarker = TestTGMarker()
    let m = PointMarker(tgMarker: tgMarker)
    _ = m.setPointEased(point, seconds: 4, easeType: .linear)
    XCTAssertEqual(tgMarker.coordinates.latitude, 40.0)
    XCTAssertEqual(tgMarker.coordinates.longitude, 70.0)
    XCTAssertEqual(tgMarker.seconds, 4)
    XCTAssertEqual(tgMarker.ease, .linear)
  }
  
}

class SystemPolylineMarkerTests: XCTestCase {

  var marker = SystemPolylineMarker()
  let mapVC = TestMapViewController()

  override func setUp() {
    super.setUp()
    mapVC.markerRemoveAll()
    marker = SystemPolylineMarker()
    mapVC.addMarker(marker)
  }

  func testTypeRouteLine() {
    XCTAssertEqual(marker.tgMarker?.stylingPath, "layers.mz_route_line.draw.ux-route-line-overlay")
    XCTAssertTrue((marker.tgMarker?.stylingString.isEmpty)!)
  }

  func testVisible() {
    XCTAssertTrue(marker.visible)
    XCTAssertTrue((marker.tgMarker?.visible)!)
    marker.visible = false
    XCTAssertFalse(marker.visible)
    XCTAssertFalse((marker.tgMarker?.visible)!)
  }

  func testDrawOrder() {
    XCTAssertEqual(marker.drawOrder, 0)
    XCTAssertEqual(marker.tgMarker?.drawOrder, 0)
    marker.drawOrder = 8
    XCTAssertEqual(marker.drawOrder, 8)
    XCTAssertEqual(marker.tgMarker?.drawOrder, 8)
  }
  
}

class TestTGMarker : TGMarker {

  @objc var coordinates: TGGeoPoint = TGGeoPoint()
  @objc var seconds: Float = 0
  @objc var ease: TGEaseType = .cubic

  private var internalMap: TGMapViewController?

  open override func pointEased(_ coordinates: TGGeoPoint, seconds: Float, easeType ease: TGEaseType) {
    self.coordinates = coordinates
    self.seconds = seconds
    self.ease = ease
  }
}
