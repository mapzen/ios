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
  func selected( location: PeliasMapkitAnnotation )
}

class RoutingViewController: UIViewController, RoutingSearchDelegate {

  @IBOutlet weak var searchBar: UITextField!
  let routeSearchSegueID = "showRouteSearchSegue"
  let routeResultEmbedSegueID = "routeResultEmbedSegue"
  var routeResultTable : RoutingResultTableVC?

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    guard let identifier = segue.identifier else {
      return
    }
    switch identifier {
    case routeSearchSegueID:
      if let searchVC = segue.destinationViewController as? RoutingSearchVC {
        searchVC.delegate = self
      }
      break
    case routeResultEmbedSegueID:
      if let resultVC = segue.destinationViewController as? RoutingResultTableVC {
        routeResultTable = resultVC
      }
      break
    default:
      break
    }
  }

  func routeTo(point: PeliasMapkitAnnotation) {
    let routingController = OTRRoutingController();
    routingController.urlQueryComponents.addObject(NSURLQueryItem(name: "apiKey", value: "mapzen-2qQR7SX"))

    let startingPoint = OTRRoutingPoint(coordinate: OTRGeoPointMake(40.7444892, -73.9900082), type: .Break)

    let endingPoint = OTRRoutingPoint(coordinate: OTRGeoPointMake(point.coordinate.latitude, point.coordinate.longitude), type: .Break)

    routingController.requestRouteWithLocations([startingPoint, endingPoint],
                                                costingModel: .Auto,
                                                costingOption: nil,
                                                directionsOptions: ["units" : "miles"]) { (routingResult, token, error) in
                                                  print(routingResult?.legs);
                                                  print("Error:\(error)")
                                                  self.routeResultTable?.display(routingResult!)

    }

  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  func selected(location: PeliasMapkitAnnotation) {
    print("Selected \(location.title)")
    searchBar.text = location.title
    routeTo(location)
  }

  /*
   // MARK: - Navigation

   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */

}
