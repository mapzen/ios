# Switching Styles
The map’s style can be configured with `MZMapViewController#loadStyleAsync`. We recommend using the asynchronous method which takes an `OnStyleLoaded` closure however, the style can also be updated synchronously.

```swift
import UIKit
import Mapzen-ios-sdk
class StyleExampleViewController:  MZMapViewController {

  private var styleLoaded = false

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
    try? loadStyleAsync(.bubbleWrap) { [unowned self] (style) in
      self.styleLoaded = true
    }
  }

  //MARK: Private
  private func setupSwitchStyleBtn() {
    let btn = UIBarButtonItem.init(title: "Map Style", style: .plain, target: self, action: #selector(showStyleActionSheet))
    self.navigationItem.rightBarButtonItem = btn
  }

  @objc private func showStyleActionSheet() {
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
}
```
