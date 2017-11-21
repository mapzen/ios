//
//  TestNotificationCenter.swift
//  MapzenSDKTests
//
//  Created by Matt Smollinger on 11/16/17.
//  Copyright © 2017 Mapzen. All rights reserved.
//

import Foundation
@testable import MapzenSDK

//This is really, really, REALLY not a fully fledged mock implementation and only does exactly what we need to test existing Notification observance. This is probably a good thing, as mocks shouldn't do that much, but be aware when using it in new tests.
class TestNotificationCenter: NotificationCenterProtocol {
  var observer: Any?
  var selector: Selector?
  var name: NSNotification.Name?
  var notificationObserverArray: [NSNotification.Name : Selector] = [:]
  var object: Any?

  func addObserver(_ observer: Any, selector aSelector: Selector, name aName: NSNotification.Name?, object anObject: Any?) {
    self.observer = observer
    notificationObserverArray[aName!] = aSelector
    object = anObject
  }

  func removeObserver(_ observer: Any) {
    self.observer = observer
  }
}
