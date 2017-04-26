//
//  TestUrlSession.swift
//  ios-sdk
//
//  Created by Sarah Lensing on 3/13/17.
//  Copyright © 2017 Mapzen. All rights reserved.
//

import Foundation
@testable import ios_sdk

class TestUrlSession : URLSession {
  var queryParameters : [String : AnyObject]?

  override func dataTask(with url: URL, completionHandler: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) -> URLSessionDataTask {
    let urlComponents = URLComponents.init(string: url.absoluteString)
    let queryItems = urlComponents?.queryItems
    let items = queryItems?.filter({ (queryItem) -> Bool in
      return queryItem.name == "json"
    })
    let jsonItem = items?[0]
    let decoded = jsonItem?.value?.removingPercentEncoding?.replacingOccurrences(of: "json=", with: "")
    if let data = decoded?.data(using: .utf8) {
      if let params = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String : AnyObject] {
        queryParameters = params
      }
    }
    return TestSessionDataTask()
  }
}
