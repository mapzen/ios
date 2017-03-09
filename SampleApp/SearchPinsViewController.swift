//
//  SearchPinsViewController.swift
//  ios-sdk
//
//  Created by Matt Smollinger on 1/6/17.
//  Copyright © 2017 Mapzen. All rights reserved.
//

import UIKit
import Pelias
import TangramMap

class SearchPinsViewController: MapViewController, UITextFieldDelegate {

  @IBOutlet weak var searchField: UITextField!

  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.bringSubview(toFront: searchField)

    try? loadStyle(.bubbleWrap)

    searchField.delegate = self
  }

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return false
  }

  func textFieldDidEndEditing(_ textField: UITextField) {
    let geopoint = GeoPoint(location: LocationManager.sharedManager.currentLocation)
    var searchConfig = PeliasSearchConfig(searchText: textField.text!) { [unowned self] (response) in
      guard let newAnnotations = response.parsedMapItems(target: self, action: #selector(self.annotationClicked(annotation:))) else { return }
      do {
        try self.removeAnnotations()
        try self.add(newAnnotations)
      } catch {
        //We theoretically would handle these with an error message to the user, but this can be left as an exercise to the reader, cuz sample app.
      }
    }

    searchConfig.focusPoint = geopoint
    let _ = PeliasSearchManager.sharedInstance.performSearch(searchConfig)
  }

  func annotationClicked(annotation: PeliasMapkitAnnotation) {
    let coordinates = "lat: \(annotation.coordinate.latitude), lon:\(annotation.coordinate.longitude)"
    let alert = UIAlertController(title: annotation.title, message: coordinates, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
    present(alert, animated: true, completion: nil)
  }
}
