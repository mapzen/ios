//
//  MapzenResponse.swift
//  ios-sdk
//
//  Created by Sarah Lensing on 3/21/17.
//  Copyright © 2017 Mapzen. All rights reserved.
//

import Foundation
import Pelias

public class MapzenResponse : NSObject {
  let peliasResponse: PeliasResponse

  //TODO
  //  private lazy var internalParsedError: MapzenSearchError?

  public var data: Data? {
    get {
      return peliasResponse.data
    }
  }

  public var response: URLResponse? {
    get {
      return peliasResponse.response
    }
  }

  public var error: NSError? {
    get {
      return peliasResponse.error
    }
  }

  //TODO: create wrapper
  //  public var parsedResponse: PeliasSearchResponse? {

  //TODO:
  //  public var parsedError: MapzenSearchError? {

  init(_ response: PeliasResponse) {
    peliasResponse = response
  }

  public override func isEqual(_ object: Any?) -> Bool {
    guard let response = object as? MapzenResponse else { return false }
    return response.peliasResponse.data == peliasResponse.data &&
            response.peliasResponse.response == peliasResponse.response &&
            response.peliasResponse.error == peliasResponse.error
  }
}
