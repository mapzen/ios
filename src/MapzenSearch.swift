//
//  MapzenSearch.swift
//  Pods
//
//  Created by Sarah Lensing on 3/27/17.
//
//

import Pelias

public class MapzenSearch : NSObject {

  public static let sharedInstance = MapzenSearch()
  private let peliasSearchManager = PeliasSearchManager.sharedInstance

  //In seconds
  public var autocompleteTimeDelay: Double {
    get {
      return peliasSearchManager.autocompleteTimeDelay
    }
    set(delay) {
      peliasSearchManager.autocompleteTimeDelay = delay
    }
  }

  public var baseUrl: URL {
    get {
      return peliasSearchManager.baseUrl
    }
    set(url) {
      peliasSearchManager.baseUrl = url
    }
  }

  public var urlQueryItems: [URLQueryItem]? {
    get {
      return peliasSearchManager.urlQueryItems
    }
    set(queryItems) {
      peliasSearchManager.urlQueryItems = queryItems
    }
  }

  fileprivate override init() {
  }

  public func search(_ config: SearchConfig) -> SearchOperation {
    let peliasOperation = peliasSearchManager.performSearch(config.peliasConfig);
    return SearchOperation.init(peliasOperation)
  }

  public func reverseGeocode(_ config: ReverseConfig) -> SearchOperation {
    let peliasOperation = peliasSearchManager.reverseGeocode(config.peliasConfig)
    return SearchOperation.init(peliasOperation)
  }

  public func autocompleteQuery(_ config: AutocompleteConfig) -> SearchOperation {
    let peliasOperation = peliasSearchManager.autocompleteQuery(config.peliasConfig)
    return SearchOperation.init(peliasOperation)
  }

  public func placeQuery(_ config: PlaceConfig) -> SearchOperation {
    let peliasOperation = peliasSearchManager.placeQuery(config.peliasConfig)
    return SearchOperation.init(peliasOperation)
  }

  public func cancelOperations() {
    peliasSearchManager.cancelOperations()
  }
}

@objc(MZSearchOperation)
public class SearchOperation : Operation {

  let peliasOperation: PeliasOperation

  init(_ op: PeliasOperation) {
    peliasOperation = op
  }

  override public func start() {
    peliasOperation.start()
  }

  override public func main() {
    peliasOperation.main()
  }


  override public var isCancelled: Bool {
    get {
      return peliasOperation.isCancelled
    }
  }

  override public func cancel() {
    peliasOperation.cancel()
  }

  override public var isExecuting: Bool {
    get {
      return peliasOperation.isExecuting
    }
  }

  override public var isFinished: Bool {
    get {
      return peliasOperation.isFinished
    }
  }

  override public var isConcurrent: Bool {
    get {
      return peliasOperation.isConcurrent
    }
  }

  override public var isAsynchronous: Bool {
    get {
      return peliasOperation.isAsynchronous
    }
  }

  override public var isReady: Bool {
    get {
      return peliasOperation.isReady
    }
  }

  override public func addDependency(_ op: Operation) {
    peliasOperation.addDependency(op)
  }

  override public func removeDependency(_ op: Operation) {
    peliasOperation.removeDependency(op)
  }

  override public var dependencies: [Operation] {
    get {
      return peliasOperation.dependencies
    }
  }

  override public var queuePriority: Operation.QueuePriority {
    get {
      return peliasOperation.queuePriority
    }
    set {
      peliasOperation.queuePriority = newValue
    }
  }

  override public var completionBlock: (() -> Swift.Void)? {
    get {
      return peliasOperation.completionBlock
    }
    set {
      peliasOperation.completionBlock = newValue
    }
  }

  override public func waitUntilFinished() {
    peliasOperation.waitUntilFinished()
  }

  override public var threadPriority: Double {
    get {
      return peliasOperation.threadPriority
    }
    set {
      peliasOperation.threadPriority = newValue
    }
  }

  override public var qualityOfService: QualityOfService {
    get {
      return peliasOperation.qualityOfService
    }
    set {
      peliasOperation.qualityOfService = newValue
    }
  }

  override public var name: String? {
    get {
      return peliasOperation.name
    }
    set {
      peliasOperation.name = newValue
    }
  }

}

@objc(MZSearchError)
public class SearchError: NSObject {

  let peliasError: PeliasError

  public var code: String {
    get {
      return peliasError.code
    }
  }

  public var message: String {
    get {
      return peliasError.message
    }
  }

  init(_ error: PeliasError) {
    peliasError = error
  }
}

