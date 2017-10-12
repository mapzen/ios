//
//  DemoMapViewController.swift
//  ios-sdk
//
//  Created by Matt Smollinger on 7/12/16.
//  Copyright © 2016 Mapzen. All rights reserved.
//

import UIKit
import TangramMap
import Mapzen_ios_sdk

class DemoMapViewController:  SampleMapViewController, MapMarkerSelectDelegate {

  private var styleLoaded = false

  @objc lazy var activityIndicator : UIActivityIndicatorView = {
    let indicator = UIActivityIndicatorView.init(activityIndicatorStyle: .whiteLarge)
    indicator.color = .black
    indicator.translatesAutoresizingMaskIntoConstraints = false
    self.view.addSubview(indicator)

    let xConstraint = indicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
    let yConstraint = indicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
    NSLayoutConstraint.activate([xConstraint, yConstraint])

    return indicator
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    setupSwitchStyleBtn()
    setupSwitchLocaleBtn()
    setupStyleNotification()
    markerSelectDelegate = self
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    try? loadStyleSheetAsync(appDelegate.selectedMapStyle) { (style) in
      self.styleLoaded = true
      let _ = self.showCurrentLocation(true)
      self.showFindMeButon(true)
    }
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "displayStyleSelector" {
      let destVC = segue.destination as! UINavigationController
      let styleVC = destVC.viewControllers[0] as! StylePickerVC
      styleVC.mapController = self
    }
  }
  
  //MARK : MapSelectDelegate  
  @objc func mapController(_ controller: MZMapViewController, didSelectMarker marker: GenericMarker, atScreenPosition position: CGPoint) {
    let alert = UIAlertController(title: "Marker Selected", message: nil, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
    present(alert, animated: true, completion: nil)
  }

  //MARK : Private
  private func setupSwitchStyleBtn() {
    let btn = UIBarButtonItem.init(title: "Map Style", style: .plain, target: self, action: #selector(openSettings))
    self.navigationItem.rightBarButtonItem = btn
  }

  private func setupSwitchLocaleBtn() {
    let btn = UIBarButtonItem.init(title: "Map Language", style: .plain, target: self, action: #selector(changeMapLanguage))
    self.navigationItem.leftBarButtonItem = btn
  }

  @objc private func openSettings() {
    performSegue(withIdentifier: "displayStyleSelector", sender: self)
  }


  @objc private func changeMapLanguage() {
    let languageIdByActionSheetTitle = [
      "English": "en_US",
      "French": "fr_FR",
      "Japanese": "ja_JP",
      "Hindi": "hi_IN",
      "Spanish": "es_ES",
      "Korean": "ko_KR",
      "Italian": "it_IT",
      "OSM Default": "none",
      ]
    let actionSheet = UIAlertController.init(title: "Map Language", message: "Choose a language", preferredStyle: .actionSheet)
    for (actionTitle, languageIdentifier) in languageIdByActionSheetTitle {
      if (languageIdentifier == "none") {
        actionSheet.addAction(UIAlertAction.init(title: actionTitle, style: .default, handler: { [unowned self] (action) in
          let update = TGSceneUpdate(path: "global.ux_language", value: "")
          self.tgViewController.updateSceneAsync([update])
        }))
        continue
      }
      actionSheet.addAction(UIAlertAction.init(title: actionTitle, style: .default, handler: { [unowned self] (action) in
        self.updateLocale(Locale.init(identifier: languageIdentifier))
      }))
    }
    actionSheet.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: { [unowned self] (action) in
      self.dismiss(animated: true, completion: nil)
    }))
    let presentationController = actionSheet.popoverPresentationController
    presentationController?.barButtonItem = self.navigationItem.leftBarButtonItem
    self.navigationController?.present(actionSheet, animated: true, completion: nil)

  }
}
