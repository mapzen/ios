//
//  RouteDisplayViewController.swift
//  ios-sdk
//
//  Created by Matt Smollinger on 1/15/17.
//  Copyright © 2017 Mapzen. All rights reserved.
//

import OnTheRoad

class RouteDisplayViewController: SampleMapViewController {

  var routingResult: OTRRoutingResult?

  override func viewDidLoad() {
    super.viewDidLoad()
    try? loadStyle(.bubbleWrap)
  }

  func show(_ route : OTRRoutingResult){
    routingResult = route
    let _ = try? display(route)
  }

}
