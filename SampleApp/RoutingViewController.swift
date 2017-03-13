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
  func selected(_ location: PeliasMapkitAnnotation)
}

class RoutingViewController: UIViewController, RoutingSearchDelegate {

  @IBOutlet weak var searchBar: UITextField!
  let routeSearchSegueID = "showRouteSearchSegue"
  let routeResultEmbedSegueID = "routeResultEmbedSegue"
  let routeListSegueId = "routeListSegue"
  var routeResultTable : RouteDisplayViewController?
  var currentRouteResult: OTRRoutingResult?
  private var routingLocale = Locale.current {
    didSet {
      requestRoute()
    }
  }
  private var destination : OTRGeoPoint?

  override func viewDidLoad() {
    super.viewDidLoad()
    setupSwitchLocaleBtn()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    if LocationManager.sharedManager.isAlwaysAuthorized() || LocationManager.sharedManager.isInUseAuthorized() {
      LocationManager.sharedManager.startUpdatingLocation()
      return
    }
    LocationManager.sharedManager.requestWhenInUseAuthorization()
  }

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

  // MARK : RoutingSearchDelegate
  func selected(_ location: PeliasMapkitAnnotation) {
    print("Selected \(location.title)")
    searchBar.text = location.title
    destination = OTRGeoPointMake(location.coordinate.latitude, location.coordinate.longitude)
    requestRoute()
  }

  // MARK : private
  private func setupSwitchLocaleBtn() {
    let btn = UIBarButtonItem.init(title: "Change Router Language", style: .plain, target: self, action: #selector(changeRouterLanguage))
    self.navigationItem.rightBarButtonItem = btn
  }

  @objc private func changeRouterLanguage() {
    let actionSheet = UIAlertController.init(title: "Router Language", message: "Choose a language", preferredStyle: .actionSheet)
    actionSheet.addAction(UIAlertAction.init(title: "English", style: .default, handler: { [unowned self] (action) in
      self.routingLocale = Locale.init(identifier: "en_US")
    }))
    actionSheet.addAction(UIAlertAction.init(title: "French", style: .default, handler: { [unowned self] (action) in
      self.routingLocale = Locale.init(identifier: "fr_FR")
    }))
    actionSheet.addAction(UIAlertAction.init(title: "Catalan", style: .default, handler: { [unowned self] (action) in
      self.routingLocale = Locale.init(identifier: "ca-ES")
    }))
    actionSheet.addAction(UIAlertAction.init(title: "Hindi", style: .default, handler: { [unowned self] (action) in
      self.routingLocale = Locale.init(identifier: "hi-IN")
    }))
    actionSheet.addAction(UIAlertAction.init(title: "Spanish", style: .default, handler: { [unowned self] (action) in
      self.routingLocale = Locale.init(identifier: "es_ES")
    }))
    actionSheet.addAction(UIAlertAction.init(title: "Czech", style: .default, handler: { [unowned self] (action) in
      self.routingLocale = Locale.init(identifier: "cs-CZ")
    }))
    actionSheet.addAction(UIAlertAction.init(title: "Italian", style: .default, handler: { [unowned self] (action) in
      self.routingLocale = Locale.init(identifier: "it_IT")
    }))
    actionSheet.addAction(UIAlertAction.init(title: "German", style: .default, handler: { [unowned self] (action) in
      self.routingLocale = Locale.init(identifier: "de-DE")
    }))
    actionSheet.addAction(UIAlertAction.init(title: "Slovenian", style: .default, handler: { [unowned self] (action) in
      self.routingLocale = Locale.init(identifier: "sl-SI")
    }))
    actionSheet.addAction(UIAlertAction.init(title: "Pirate", style: .default, handler: { [unowned self] (action) in
      self.routingLocale = Locale.init(identifier: "en-US-x-pirate")
    }))
    actionSheet.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: { [unowned self] (action) in
      self.dismiss(animated: true, completion: nil)
    }))
    self.navigationController?.present(actionSheet, animated: true, completion: nil)
  }

  private func requestRoute() {
    guard let routingController = try? MapzenRoutingController.controller() else { return }
    routingController.updateLocale(routingLocale)

    guard let currentLocation = LocationManager.sharedManager.currentLocation, let destination = destination else { return }
    let startingPoint = OTRRoutingPoint(coordinate: OTRGeoPointMake(currentLocation.coordinate.latitude, currentLocation.coordinate.longitude), type: .break)
    let endingPoint = OTRRoutingPoint(coordinate: destination, type: .break)

    _ = routingController.requestRoute(withLocations: [startingPoint, endingPoint],
                                       costingModel: .auto,
                                       costingOption: nil,
                                       directionsOptions: ["units" : "miles" as NSObject]) { (routingResult, token, error) in
                                        print("Error:\(error)")
                                        self.currentRouteResult = routingResult
                                        self.routeResultTable?.show(routingResult!)

    }

  }

}
