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
    self.loadScene("scene.yaml", apiKey: "mapzen-2qQR7SX")
    PeliasSearchManager.sharedInstance.urlQueryItems = [NSURLQueryItem(name: "api_key", value: "mapzen-2qQR7SX")]

    searchField.delegate = self
  }

  func textFieldShouldReturn(textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return false
  }

  func textFieldDidEndEditing(textField: UITextField) {
    let geopoint = GeoPoint(location: LocationManager.sharedManager.currentLocation)
    let weakSelf = self
    var searchConfig = PeliasSearchConfig(searchText: textField.text!) { (response) in
      guard let newAnnotations = response.parsedMapItems() else { return }
      let strongSelf = weakSelf
      strongSelf.removeAnnotations()
      strongSelf.add(newAnnotations)
    }

    searchConfig.focusPoint = geopoint
    PeliasSearchManager.sharedInstance.performSearch(searchConfig)
  }
}
