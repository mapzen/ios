//
//  MapzenSearchDataObjectsTests.swift
//  ios-sdk
//
//  Created by Sarah Lensing on 3/21/17.
//  Copyright © 2017 Mapzen. All rights reserved.
//

import XCTest
@testable import ios_sdk
import Pelias

class MapzenSearchDataObjectsTests: XCTestCase {

  func testSearchRect() {
    let min = MzGeoPoint(latitude: 70.0, longitude: 40.0)
    let max = MzGeoPoint(latitude: 80.0, longitude: 50.0)
    let searchRect = MzSearchRect(minLatLong: min, maxLatLong: max)
    let rect = SearchBoundaryRect(minLatLong: MapzenSearchDataConverter.unwrapPoint(min), maxLatLong: MapzenSearchDataConverter.unwrapPoint(max))
    XCTAssertEqual(searchRect.rect, rect)
    XCTAssertEqual(searchRect, MzSearchRect(minLatLong: min, maxLatLong: max))
  }

  func testSearchCircle() {
    let center = MzGeoPoint(latitude: 70.0, longitude: 40.0)
    let searchCircle = MzSearchCircle(center: center, radius: 8)
    let circle = SearchBoundaryCircle(center: MapzenSearchDataConverter.unwrapPoint(center), radius: 8)
    XCTAssertEqual(searchCircle.circle, circle)
    XCTAssertEqual(searchCircle, MzSearchCircle(center: center, radius: 8))
  }

  func testGeoPoint() {
    let point = MzGeoPoint(latitude: 70.0, longitude: 40.0)
    let peliasPoint = GeoPoint(latitude: 70.0, longitude: 40.0)
    XCTAssertEqual(point.point, peliasPoint)
    XCTAssertEqual(point, MzGeoPoint(latitude: 70.0, longitude: 40.0))
  }

  func testPlaceQueryItem() {
    let item = MzPlaceQueryItem(placeId: "id", dataSource: .geoNames, layer: .address)
    let peliasItem = PeliasPlaceQueryItem(placeId: "id", dataSource: .GeoNames, layer: .address)
    XCTAssertEqual(item.peliasItem.placeId, peliasItem.placeId)
    XCTAssertEqual(item.peliasItem.dataSource, peliasItem.dataSource)
    XCTAssertEqual(item.peliasItem.layer, peliasItem.layer)
    XCTAssertEqual(item, MzPlaceQueryItem(placeId: "id", dataSource: .geoNames, layer: .address))
  }
}
