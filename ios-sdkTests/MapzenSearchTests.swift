//
//  MapzenSearchTests.swift
//  ios-sdk
//
//  Created by Sarah Lensing on 3/28/17.
//  Copyright © 2017 Mapzen. All rights reserved.
//

import XCTest
@testable import ios_sdk
import Pelias

public class MapzenSearchTests : XCTestCase {

  let mapzenSearch = MapzenSearch.sharedInstance
  let peliasSearchManager = PeliasSearchManager.sharedInstance

  func testAutocompleteTimeDelay() {
    mapzenSearch.autocompleteTimeDelay = 3
    XCTAssertEqual(3, mapzenSearch.autocompleteTimeDelay)
    XCTAssertEqual(3, peliasSearchManager.autocompleteTimeDelay)
  }

  func testBaseUrl() {
    let defaultBaseUrl = URL.init(string: Constants.URL.base)
    XCTAssertEqual(mapzenSearch.baseUrl, defaultBaseUrl)
    XCTAssertEqual(peliasSearchManager.baseUrl, defaultBaseUrl)

    let baseUrl = URL.init(string: "https://search.custom.com")!
    mapzenSearch.baseUrl = baseUrl
    XCTAssertEqual(mapzenSearch.baseUrl, baseUrl)
    XCTAssertEqual(peliasSearchManager.baseUrl, baseUrl)
  }

  func testQueryItems() {
    let items = [URLQueryItem.init(name: "test", value: "val")]
    mapzenSearch.urlQueryItems = items
    XCTAssertEqual(mapzenSearch.urlQueryItems!, items)
    XCTAssertEqual(peliasSearchManager.urlQueryItems!, items)
  }

  func testSearchQuery() {
    let config = SearchConfig.init(searchText: "test") { (response) in
      //
    }
    let operation = mapzenSearch.search(config)
    XCTAssertNotNil(operation)
  }

  func testReverseQuery() {
    let config = ReverseConfig.init(point: GeoPoint.init(latitude: 40, longitude: 40)) { (response) in
      //
    }
    let operation = mapzenSearch.reverseGeocode(config)
    XCTAssertNotNil(operation)
  }

  func testAutocompleteQuery() {
    let config = AutocompleteConfig.init(searchText: "test", focusPoint: GeoPoint.init(latitude: 40, longitude: 40)) { (response) in
      //
    }
    let operation = mapzenSearch.autocompleteQuery(config)
    XCTAssertNotNil(operation)
  }

  func testPlaceQuery() {
    let config = PlaceConfig.init(places: [PlaceQueryItem.init(placeId: "", dataSource: .openAddresses, layer: .address)]) { (response) in
      //
    }
    let operation = mapzenSearch.placeQuery(config)
    XCTAssertNotNil(operation)
  }
}

class SearchOperationTests : XCTestCase {
  let operation = SearchOperation.init(TestPeliasOperation())

  func testStart() {
    operation.start()
    let peliasOperation = operation.peliasOperation as! TestPeliasOperation
    XCTAssertTrue(peliasOperation.started)
  }

  func testMain() {
    operation.main()
    let peliasOperation = operation.peliasOperation as! TestPeliasOperation
    XCTAssertTrue(peliasOperation.calledMain)
  }

  func testIsCancelled() {
    let peliasOperation = operation.peliasOperation as! TestPeliasOperation
    XCTAssertEqual(operation.isCancelled, peliasOperation.isCancelled)
    operation.cancel()
    XCTAssertEqual(operation.isCancelled, peliasOperation.isCancelled)
  }

  func testCancel() {
    operation.cancel()
    let peliasOperation = operation.peliasOperation as! TestPeliasOperation
    XCTAssertTrue(peliasOperation.calledCancel)
  }

  func testIsExecuting() {
    operation.start()
    let peliasOperation = operation.peliasOperation as! TestPeliasOperation
    XCTAssertTrue(operation.isExecuting)
    XCTAssertEqual(operation.isExecuting, peliasOperation.isExecuting)
    operation.waitUntilFinished()
    XCTAssertEqual(operation.isExecuting, peliasOperation.isExecuting)
    XCTAssertEqual(operation.isExecuting, false)
  }

  func testIsFinished() {
    operation.start()
    let peliasOperation = operation.peliasOperation as! TestPeliasOperation
    XCTAssertEqual(operation.isFinished, peliasOperation.isFinished)
    operation.waitUntilFinished()
    XCTAssertEqual(operation.isFinished, peliasOperation.isFinished)
    XCTAssertEqual(operation.isFinished, true)
  }

  func testIsConcurrent() {
    let peliasOperation = operation.peliasOperation as! TestPeliasOperation
    XCTAssertEqual(operation.isConcurrent, peliasOperation.isConcurrent)
  }

  func testIsAsynchronous() {
    let peliasOperation = operation.peliasOperation as! TestPeliasOperation
    XCTAssertEqual(operation.isAsynchronous, peliasOperation.isAsynchronous)
  }

  func testIsReady() {
    let peliasOperation = operation.peliasOperation as! TestPeliasOperation
    XCTAssertEqual(operation.isReady, peliasOperation.isReady)
  }

  func testAddDependency() {
    let peliasOperation = operation.peliasOperation as! TestPeliasOperation
    let dep = Operation.init()
    operation.addDependency(dep)
    XCTAssertEqual(operation.dependencies, peliasOperation.dependencies)
    XCTAssertTrue(operation.dependencies.contains(dep))
    XCTAssertEqual(operation.dependencies.count, 1)
  }

  func testRemoveDependency() {
    let peliasOperation = operation.peliasOperation as! TestPeliasOperation
    let dep = Operation.init()
    operation.addDependency(dep)
    operation.removeDependency(dep)
    XCTAssertEqual(operation.dependencies, peliasOperation.dependencies)
    XCTAssertFalse(operation.dependencies.contains(dep))
    XCTAssertEqual(operation.dependencies.count, 0)
  }

  func testDependencies() {
    let peliasOperation = operation.peliasOperation as! TestPeliasOperation
    XCTAssertEqual(operation.dependencies, peliasOperation.dependencies)
  }

  func testQueuePriority() {
    let peliasOperation = operation.peliasOperation as! TestPeliasOperation
    XCTAssertEqual(operation.queuePriority, peliasOperation.queuePriority)
    operation.queuePriority = .high
    XCTAssertEqual(operation.queuePriority, peliasOperation.queuePriority)
    XCTAssertEqual(operation.queuePriority, .high)
  }

  func testCompletionBlock() {
    let peliasOperation = operation.peliasOperation as! TestPeliasOperation
    var blockExecuted = false
    let block = {() in
      blockExecuted = true
    }
    operation.completionBlock = block
    operation.start()
    operation.waitUntilFinished()
    XCTAssertNotNil(operation.completionBlock)
    XCTAssertNotNil(peliasOperation.completionBlock)
    XCTAssertTrue(blockExecuted)
  }

  func testThreadPriority() {
    let peliasOperation = operation.peliasOperation as! TestPeliasOperation
    XCTAssertEqual(operation.threadPriority, peliasOperation.threadPriority)
    operation.threadPriority = 2.0
    XCTAssertEqual(operation.threadPriority, peliasOperation.threadPriority)
    XCTAssertEqual(operation.threadPriority, 2.0)
  }

  func testQualityOfService() {
    let peliasOperation = operation.peliasOperation as! TestPeliasOperation
    XCTAssertEqual(operation.qualityOfService, peliasOperation.qualityOfService)
    operation.qualityOfService = .background
    XCTAssertEqual(operation.qualityOfService, peliasOperation.qualityOfService)
    XCTAssertEqual(operation.qualityOfService, .background)
  }

  func testName() {
    let peliasOperation = operation.peliasOperation as! TestPeliasOperation
    XCTAssertEqual(operation.name, peliasOperation.name)
    operation.name = "test"
    XCTAssertEqual(operation.name, peliasOperation.name)
    XCTAssertEqual(operation.name, "test")
  }

  class TestPeliasOperation : PeliasOperation {

    var started: Bool = false
    var calledMain: Bool = false
    var calledCancel: Bool = false
    var internalIsFinished: Bool = false
    var internalIsExecuting: Bool = false
    var internalThreadPriority: Double = 0.0

    init() {
      super.init(config: PeliasSearchConfig.init(searchText: "test", completionHandler: { (response) in
        //
      }))
    }

    override func start() {
      started = true
      internalIsExecuting = true
    }

    override func main() {
      calledMain = true
    }

    override func cancel() {
      calledCancel = true
    }

    override var isFinished: Bool {
      get {
        return internalIsFinished
      }
    }

    override var isExecuting: Bool {
      get {
        return internalIsExecuting
      }
    }

    override var threadPriority: Double {
      get {
        return internalThreadPriority
      }
      set {
        internalThreadPriority = newValue
      }
    }

    override func waitUntilFinished() {
      internalIsExecuting = false
      internalIsFinished = true
      guard let block = completionBlock else { return }
      block()
    }
  }
}

class SearchErrorTests : XCTestCase {

  let error = SearchError.init(PeliasError.init(code: "code", message: "msg"))

  func testCode() {
    XCTAssertEqual(error.code, "code")
  }

  func testMessage() {
    XCTAssertEqual(error.message, "msg")
  }
}
