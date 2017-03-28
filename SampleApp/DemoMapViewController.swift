//
//  TangramVC.swift
//  ios-sdk
//
//  Created by Matt Smollinger on 7/12/16.
//  Copyright © 2016 Mapzen. All rights reserved.
//

import UIKit
import TangramMap
class DemoMapViewController:  SampleMapViewController, MapMarkerSelectDelegate {

  private var styleLoaded = false
  private var markerVisible = false

  lazy var activityIndicator : UIActivityIndicatorView = {
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
    markerSelectDelegate = self
    try? loadStyleAsync(.bubbleWrap) { [unowned self] (style) in
      self.styleLoaded = true
      let _ = self.showCurrentLocation(true)
      self.showFindMeButon(true)
    }
  }
  
  //MARK : MapSelectDelegate  
  func mapController(_ controller: MapViewController, didSelectMarker markerPickResult: TGMarkerPickResult, atScreenPosition position: CGPoint) {
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
    let actionSheet = UIAlertController.init(title: "Map Style", message: "Choose a map style", preferredStyle: .actionSheet)
    actionSheet.addAction(UIAlertAction.init(title: "Bubble Wrap", style: .default, handler: { [unowned self] (action) in
      self.indicateLoadStyle(style: .bubbleWrap)
    }))
    actionSheet.addAction(UIAlertAction.init(title: "Cinnabar", style: .default, handler: { [unowned self] (action) in
      self.indicateLoadStyle(style: .cinnabar)
    }))
    actionSheet.addAction(UIAlertAction.init(title: "Refill", style: .default, handler: { [unowned self] (action) in
      self.indicateLoadStyle(style: .refill)
    }))
    actionSheet.addAction(UIAlertAction.init(title: "Walkabout", style: .default, handler: { [unowned self] (action) in
      self.indicateLoadStyle(style: .walkabout)
    }))
    actionSheet.addAction(UIAlertAction.init(title: "Zinc", style: .default, handler: { [unowned self] (action) in
      self.indicateLoadStyle(style: .zinc)
    }))
    actionSheet.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: { [unowned self] (action) in
      self.dismiss(animated: true, completion: nil)
    }))
    self.navigationController?.present(actionSheet, animated: true, completion: nil)
  }

  private func indicateLoadStyle(style: MapStyle) {
    activityIndicator.startAnimating()
    try? loadStyleAsync(style, onStyleLoaded: { [unowned self] (style) in
      self.activityIndicator.stopAnimating()
    })
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
