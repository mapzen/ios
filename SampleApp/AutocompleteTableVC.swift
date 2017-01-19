//
//  AutocompleteTableVC.swift
//  ios-sdk
//
//  Created by Matt Smollinger on 7/12/16.
//  Copyright © 2016 Mapzen. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Pelias

class AutocompleteTableVC: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate, LocationManagerDelegate {
  
  let searchController = UISearchController(searchResultsController: nil)
  var results: [PeliasMapkitAnnotation]?
  let manager = LocationManager.sharedManager
  var currentLocation: CLLocation?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    searchController.searchResultsUpdater = self
    searchController.dimsBackgroundDuringPresentation = false
    searchController.searchBar.delegate = self
    self.tableView.tableHeaderView = searchController.searchBar
    self.definesPresentationContext = true
    searchController.searchBar.sizeToFit()
    manager.delegate = self
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    if manager.isInUseAuthorized() || manager.isAlwaysAuthorized() {
      manager.requestLocation()
      return
    }
    manager.requestWhenInUseAuthorization()
  }

  // MARK: - Table view data source
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let unwrappedResults = results {
      return unwrappedResults.count
    }
    return 0
  }
  
  func updateSearchResultsForSearchController(searchController: UISearchController) {
    if let searchText = searchController.searchBar.text where searchController.searchBar.text?.isEmpty == false {
      var geoPoint = GeoPoint(latitude: 40.7312973034393, longitude: -73.99896644276561)
      if let location = currentLocation {
        geoPoint = GeoPoint(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
      }
      let config = PeliasAutocompleteConfig(searchText: searchText, focusPoint: geoPoint, completionHandler: { (autocompleteResponse) -> Void in
        self.results = autocompleteResponse.parsedMapItems()
        self.tableView.reloadData()
      })
      PeliasSearchManager.sharedInstance.autocompleteQuery(config)
    }
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("basicCellIdent", forIndexPath: indexPath)
    cell.textLabel?.text = results?[indexPath.row].title
    return cell
  }

  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    searchController.searchBar.resignFirstResponder()
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
  }

  //MARK: - LocationManager Delegate

  func authorizationDidSucceed() {
    manager.startUpdatingLocation()
  }

  func locationDidUpdate(location: CLLocation) {
    currentLocation = location
  }
}
