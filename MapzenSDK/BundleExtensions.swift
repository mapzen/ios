//
//  BundleExtensions.swift
//  ios-sdk
//
//  Created by Sarah Lensing on 4/17/17.
//  Copyright © 2017 Mapzen. All rights reserved.
//

import Foundation

extension Bundle {
  public static func mapzenBundle() -> Bundle {
    return Bundle.init(for: MZMapViewController.self)
  }

  public static func houseStylesBundle() -> Bundle? {
    guard let styleBundleUrl = Bundle.mapzenBundle().url(forResource: "housestyles", withExtension: "bundle") else {
      return nil
    }
    return Bundle.init(url: styleBundleUrl)
  }
}
