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

class SearchPinsViewController: MapViewController, UITextFieldDelegate, MapMarkerSelectDelegate {

  @IBOutlet weak var searchField: UITextField!

  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.bringSubview(toFront: searchField)

    try? loadSceneFile("scene.yaml")

    searchField.delegate = self
    markerSelectDelegate = self
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

  // MARK : MapMarkerSelectDelegate
  func mapController(_ controller: MapViewController, didSelectMarker markerPickResult: TGMarkerPickResult, atScreenPosition position: CGPoint) {
    let markerId = markerPickResult.identifier
    guard let annotation = currentAnnotations.keyForValue(value: markerId) else { return }
    let coordinates = "lat: \(annotation.coordinate.latitude), lon:\(annotation.coordinate.longitude)"
    let alert = UIAlertController(title: annotation.title, message: coordinates, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
    present(alert, animated: true, completion: nil)
  }
}
