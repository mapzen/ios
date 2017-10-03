//
//  StylePickerVC.swift
//  ios-sdk
//
//  Created by Matt Smollinger on 10/3/17.
//  Copyright © 2017 Mapzen. All rights reserved.
//

import UIKit
import Mapzen_ios_sdk

class StylePickerVC: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate {


  @IBOutlet var styleSheetPicker: UIPickerView!
  @IBOutlet var colorPicker: UIPickerView!

  @IBOutlet var levelOfDetailText: UITextField!
  @IBOutlet var labelDensityText: UITextField!

  @IBOutlet var transitOverlaySwitch: UISwitch!
  @IBOutlet var bikeOverlaySwitch: UISwitch!
  @IBOutlet var walkingOverlaySwitch: UISwitch!

  weak var mapController : SampleMapViewController?
  var currentSelectedStyle: StyleSheet?
  var availableStyles : [ String : StyleSheet ] = ["Bubble Wrap" : BubbleWrapStyle(),
                         "Cinnabar" : CinnabarStyle(),
                         "Refill" : RefillStyle(),
                         "Walkabout" : WalkaboutStyle(),
                         "Zinc" : ZincStyle()]

  override func viewDidLoad() {
    super.viewDidLoad()
    transitOverlaySwitch.setOn(mapController!.showTransitOverlay, animated: true)
    transitOverlaySwitch.addTarget(self, action: #selector(transitOverlaySwitchChanged(switchState:)), for: .valueChanged)

    bikeOverlaySwitch.setOn(mapController!.showBikeOverlay, animated: true)
    bikeOverlaySwitch.addTarget(self, action: #selector(bikeOverlaySwitchChanged(switchState:)), for: .valueChanged)

    walkingOverlaySwitch.setOn(mapController!.showWalkingPathOverlay, animated: true)
    walkingOverlaySwitch.addTarget(self, action: #selector(walkingOverlaySwitchChanged(switchState:)), for: .valueChanged)

    currentSelectedStyle = mapController?.selectedMapStyle

    guard let style = currentSelectedStyle else { return }
    setUIStateForStyle(styleSheet: style)
  }

  func transitOverlaySwitchChanged(switchState: UISwitch) {

  }
  func bikeOverlaySwitchChanged(switchState: UISwitch) {
    if switchState.isOn {
      walkingOverlaySwitch.setOn(false, animated: true)
    }

  }
  func walkingOverlaySwitchChanged(switchState: UISwitch) {
    if switchState.isOn {
      bikeOverlaySwitch.setOn(false, animated: true)
    }

  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    let values = Array(availableStyles.values)
    let index = values.index { (style) -> Bool in
      style.importString == currentSelectedStyle!.importString
    }
    styleSheetPicker.selectRow(index!, inComponent: 0, animated: true)
  }
  // MARK: - Table view data source

//  override func numberOfSections(in tableView: UITableView) -> Int {
//    // #warning Incomplete implementation, return the number of sections
//    return 0
//  }

//  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//    // #warning Incomplete implementation, return the number of rows
//    return 0
//  }

  //MARK:- Picker View
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }

  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    if pickerView == styleSheetPicker {
      return 5
    }
    if pickerView == colorPicker {
      guard let style = currentSelectedStyle else { return 1 }
      if style.appliedTheme.availableColors.count > 0 {
        // We want to return 1 in the event we have no colors to show "No Colors" so just need this
        return style.appliedTheme.availableColors.count
      }
    }
    return 1
  }

  @IBAction func savePressed(_ sender: Any) {

    mapController?.showWalkingPathOverlay = walkingOverlaySwitch.isOn
    mapController?.showTransitOverlay = transitOverlaySwitch.isOn
    mapController?.showBikeOverlay = bikeOverlaySwitch.isOn
    mapController?.selectedMapStyle = currentSelectedStyle!
    self.dismiss(animated: true, completion: nil)
  }
  @IBAction func cancelPressed(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }

  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    if pickerView == styleSheetPicker {
      let keys = Array(availableStyles.keys)
      return keys[row]
    }
    if pickerView == colorPicker {
      guard let style = currentSelectedStyle else { return "N/A" }
      if style.appliedTheme.availableColors.count == 0 { return "N/A" }
      return style.appliedTheme.availableColors[row]
    }

    return "???"
  }

  func setUIStateForStyle(styleSheet: StyleSheet) {
    colorPicker.reloadAllComponents()
    if styleSheet.appliedTheme.availableDetailLevel > 0 {
      levelOfDetailText.text = String(styleSheet.appliedTheme.detailLevel)
      levelOfDetailText.isEnabled = true
    } else {
      levelOfDetailText.text = "N/A"
      levelOfDetailText.isEnabled = false
    }

    if styleSheet.appliedTheme.availableLabelLevels > 0 {
      labelDensityText.text = String(styleSheet.appliedTheme.labelLevel)
      labelDensityText.isEnabled = true
    } else {
      labelDensityText.text = "N/A"
      labelDensityText.isEnabled = false
    }
  }

  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    if pickerView == styleSheetPicker {
      let keys = Array(availableStyles.keys)
      let style = availableStyles[keys[row]]
      currentSelectedStyle = style
      setUIStateForStyle(styleSheet: style!)
    }
    if pickerView == colorPicker {
      guard let style = currentSelectedStyle else { return }
      style.appliedTheme.currentColor = style.appliedTheme.availableColors[row]
    }
  }
}
