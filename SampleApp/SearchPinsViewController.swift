//
//  SearchPinsViewController.swift
//  ios-sdk
//
//  Created by Matt Smollinger on 1/6/17.
//  Copyright © 2017 Mapzen. All rights reserved.
//

import UIKit
import Pelias

class SearchPinsViewController: MapViewController, UITextFieldDelegate {

  @IBOutlet weak var searchField: UITextField!

  override func viewDidLoad() {
    super.viewDidLoad()
    let _ = try? loadScene("scene.yaml")

    searchField.delegate = self
  }

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return false
  }

  func textFieldDidEndEditing(_ textField: UITextField) {
    let geopoint = GeoPoint(location: LocationManager.sharedManager.currentLocation)
    var searchConfig = PeliasSearchConfig(searchText: textField.text!) { [weak self] (response) in
      guard let newAnnotations = response.parsedMapItems() else { return }
      do {
        try self?.removeAnnotations()
        try self?.add(newAnnotations)
      } catch {
        //We theoretically would handle these with an error message to the user, but this can be left as an exercise to the reader, cuz sample app.
      }
    }

    searchConfig.focusPoint = geopoint
    let _ = PeliasSearchManager.sharedInstance.performSearch(searchConfig)
  }
}
