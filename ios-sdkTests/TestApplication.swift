//
//  TestApplication.swift
//  ios-sdk
//
//  Created by Sarah Lensing on 2/24/17.
//  Copyright © 2017 Mapzen. All rights reserved.
//

import UIKit
@testable import ios_sdk

class TestApplication: ApplicationProtocol {

  open var urlToOpen : URL?

  func openURL(_ url: URL) -> Bool {
    urlToOpen = url
    return false
  }
}
