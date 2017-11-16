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

protocol NotificationCenterProtocol {
  func addObserver(_ observer: Any, selector aSelector: Selector, name aName: NSNotification.Name?, object anObject: Any?)
  func removeObserver(_ observer: Any)
}
extension NotificationCenter: NotificationCenterProtocol {}
