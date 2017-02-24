//
//  ApplicationExtensions.swift
//  ios-sdk
//
//  Created by Sarah Lensing on 2/24/17.
//  Copyright © 2017 Mapzen. All rights reserved.
//

import UIKit

protocol ApplicationProtocol {
  func openURL(_ url: URL) -> Bool
}

extension UIApplication: ApplicationProtocol {}
