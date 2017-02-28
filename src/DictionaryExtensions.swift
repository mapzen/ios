//
//  DictionaryExtensions.swift
//  ios-sdk
//
//  Created by Sarah Lensing on 2/24/17.
//  Copyright © 2017 Mapzen. All rights reserved.
//

import Foundation

public extension Dictionary where Value: Equatable {

  /* Use when keys/values are not 1:1 */
  public func keysForValue(value: Value) -> [Key] {
    return flatMap { (key: Key, val: Value) -> Key? in
      value == val ? key : nil
    }
  }

  /* Use when keys/values are 1:1*/
  public func keyForValue(value: Value) -> Key? {
    let results = keysForValue(value: value)
    guard !results.isEmpty else { return nil }
    return results.first
  }
}
