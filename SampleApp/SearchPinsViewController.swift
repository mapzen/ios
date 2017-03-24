//
//  SearchPinsViewController.swift
//  ios-sdk
//
//  Created by Matt Smollinger on 1/6/17.
//  Copyright © 2017 Mapzen. All rights reserved.
//

import Pelias
import TangramMap

class SearchPinsViewController: SampleMapViewController, UITextFieldDelegate {

  @IBOutlet weak var searchField: UITextField!

  override func viewDidLoad() {
    super.viewDidLoad()
    setupSwitchLocaleBtn()

    try? loadStyle(.bubbleWrap)
    
    self.view.bringSubview(toFront: searchField)
    searchField.delegate = self
  }

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return false
  }

  func textFieldDidEndEditing(_ textField: UITextField) {
    let geopoint = Pelias.GeoPoint(location: LocationManager.sharedManager.currentLocation)
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

  // MARK : private
  private func setupSwitchLocaleBtn() {
    let btn = UIBarButtonItem.init(title: "Change Map Language", style: .plain, target: self, action: #selector(changeMapLanguage))
    self.navigationItem.rightBarButtonItem = btn
  }

  @objc private func changeMapLanguage() {
    let actionSheet = UIAlertController.init(title: "Map Language", message: "Choose a language", preferredStyle: .actionSheet)
    actionSheet.addAction(UIAlertAction.init(title: "English", style: .default, handler: { [unowned self] (action) in
      self.updateLocale(Locale.init(identifier: "en_US"))
    }))
    actionSheet.addAction(UIAlertAction.init(title: "French", style: .default, handler: { [unowned self] (action) in
      self.updateLocale(Locale.init(identifier: "fr_FR"))
    }))
    actionSheet.addAction(UIAlertAction.init(title: "Japanese", style: .default, handler: { [unowned self] (action) in
      self.updateLocale(Locale.init(identifier: "ja_JP"))
    }))
    actionSheet.addAction(UIAlertAction.init(title: "Hindi", style: .default, handler: { [unowned self] (action) in
      self.updateLocale(Locale.init(identifier: "hi-IN"))
    }))
    actionSheet.addAction(UIAlertAction.init(title: "Spanish", style: .default, handler: { [unowned self] (action) in
      self.updateLocale(Locale.init(identifier: "es_ES"))
    }))
    actionSheet.addAction(UIAlertAction.init(title: "Korean", style: .default, handler: { [unowned self] (action) in
      self.updateLocale(Locale.init(identifier: "ko_KR"))
    }))
    actionSheet.addAction(UIAlertAction.init(title: "Italian", style: .default, handler: { [unowned self] (action) in
      self.updateLocale(Locale.init(identifier: "it_IT"))
    }))
    actionSheet.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: { [unowned self] (action) in
      self.dismiss(animated: true, completion: nil)
    }))
    self.navigationController?.present(actionSheet, animated: true, completion: nil)

  }
}
