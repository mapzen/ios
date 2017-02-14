//
//  RoutingViewController.swift
//  ios-sdk
//
//  Created by Matt Smollinger on 8/17/16.
//  Copyright © 2016 Mapzen. All rights reserved.
//

import UIKit
import OnTheRoad
import Pelias

protocol RoutingSearchDelegate {
  func selected( _ location: PeliasMapkitAnnotation )
}

class RoutingViewController: UIViewController, RoutingSearchDelegate {

  @IBOutlet weak var searchBar: UITextField!
  let routeSearchSegueID = "showRouteSearchSegue"
  let routeResultEmbedSegueID = "routeResultEmbedSegue"
  let routeListSegueId = "routeListSegue"
  var routeResultTable : RouteDisplayViewController?
  var currentRouteResult: OTRRoutingResult?

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let identifier = segue.identifier else {
      return
    }
    switch identifier {
    case routeSearchSegueID:
      if let searchVC = segue.destination as? RoutingSearchVC {
        searchVC.delegate = self
      }
      break
    case routeResultEmbedSegueID:
      if let resultVC = segue.destination as? RouteDisplayViewController {
        routeResultTable = resultVC
      }
      break
    case routeListSegueId:
      guard let routeResult = currentRouteResult else { return }
      if let vc = segue.destination as? RoutingResultTableVC {
        vc.routingResult = routeResult
      }
    default:
      break
    }
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    if LocationManager.sharedManager.isAlwaysAuthorized() || LocationManager.sharedManager.isInUseAuthorized() {
      LocationManager.sharedManager.startUpdatingLocation()
      return
    }
    LocationManager.sharedManager.requestWhenInUseAuthorization()
  }

  func routeTo(_ point: PeliasMapkitAnnotation) {
    let routingController = OTRRoutingController();
    routingController.urlQueryComponents.add(URLQueryItem(name: "apiKey", value: "mapzen-2qQR7SX"))

    var startingPoint = OTRRoutingPoint(coordinate: OTRGeoPointMake(40.7444892, -73.9900082), type: .break)
    if let location = LocationManager.sharedManager.currentLocation {
      startingPoint = OTRRoutingPoint(coordinate: OTRGeoPointMake(location.coordinate.latitude, location.coordinate.longitude), type: .break)
    }

    let endingPoint = OTRRoutingPoint(coordinate: OTRGeoPointMake(point.coordinate.latitude, point.coordinate.longitude), type: .break)

    routingController.requestRoute(withLocations: [startingPoint, endingPoint],
                                                costingModel: .auto,
                                                costingOption: nil,
                                                directionsOptions: ["units" : "miles" as NSObject]) { (routingResult, token, error) in
                                                  print(routingResult?.legs);
                                                  print("Error:\(error)")
                                                  self.currentRouteResult = routingResult
                                                  self.routeResultTable?.show(routingResult!)

    }

  }

  func selected(_ location: PeliasMapkitAnnotation) {
    print("Selected \(location.title)")
    searchBar.text = location.title
    routeTo(location)
  }
}
