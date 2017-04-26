//
//  AutocompleteTableVC.swift
//  ios-sdk
//
//  Created by Matt Smollinger on 7/12/16.
//  Copyright © 2016 Mapzen. All rights reserved.
//

import MapKit
import CoreLocation
import Pelias
import MapzenSDK

protocol AutocompleteSearchDelegate {
  func selected(_ location: PeliasMapkitAnnotation)
}

class SampleAutocompleteTableViewController: SampleTableViewController, UISearchResultsUpdating, UISearchBarDelegate, LocationManagerDelegate {
  
  let searchController = UISearchController(searchResultsController: nil)
  var results: [PeliasMapkitAnnotation]?
  let manager = LocationManager()
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
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    if manager.isInUseAuthorized() || manager.isAlwaysAuthorized() {
      manager.requestLocation()
      return
    }
    manager.requestWhenInUseAuthorization()
  }

  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let unwrappedResults = results {
      return unwrappedResults.count
    }
    return 0
  }
  
  func updateSearchResults(for searchController: UISearchController) {
    if let searchText = searchController.searchBar.text, searchController.searchBar.text?.isEmpty == false {
      var geoPoint = GeoPoint(latitude: 40.7312973034393, longitude: -73.99896644276561)
      if let location = currentLocation {
        geoPoint = GeoPoint(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
      }
      let config = AutocompleteConfig(searchText: searchText, focusPoint: geoPoint, completionHandler: { (autocompleteResponse) -> Void in
        print("Error:\(String(describing: autocompleteResponse.error))")
        if let parsedItems = autocompleteResponse.peliasResponse.parsedMapItems() {
          self.results = parsedItems
          self.tableView.reloadData()
        }
      })
      _ = MapzenSearch.sharedInstance.autocompleteQuery(config)
    }
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "basicCellIdent", for: indexPath)
    cell.textLabel?.text = results?[indexPath.row].title
    return cell
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    searchController.searchBar.resignFirstResponder()
    tableView.deselectRow(at: indexPath, animated: true)
  }

  //MARK: - LocationManager Delegate

  func authorizationDidSucceed() {
    manager.startUpdatingLocation()
  }

  func locationDidUpdate(_ location: CLLocation) {
    currentLocation = location
  }
}
