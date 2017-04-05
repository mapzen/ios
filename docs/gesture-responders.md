# Gesture Responders

The map supports taps, double taps, shoves, scales, rotations, pans, and long presses. To receive information about when these events occur, create a responder.

```swift
import Foundation
import UIKit

class GestureExampleViewController:  MZMapViewController, MapSingleTapGestureDelegate, MapDoubleTapGestureDelegate, MapLongPressGestureDelegate, MapPanGestureDelegate, MapPinchGestureDelegate, MapRotateGestureDelegate, MapShoveGestureDelegate {

  override func viewDidLoad() {
    super.viewDidLoad()

    try? loadStyleAsync(.bubbleWrap) { [unowned self] (style) in
      self.setupDelegates()
    }
  }

  //MARK: Private
  private func setupDelegates() {
    self.singleTapGestureDelegate = self
    self.doubleTapGestureDelegate = self
    self.longPressGestureDelegate = self
    self.panDelegate = self
    self.pinchDelegate = self
    self.rotateDelegate = self
    self.shoveDelegate = self
  }

  private func logGesture(_ gesture: String) {
    print("Gesture: \(gesture)")
  }

  //MARK: MapSingleTapGestureDelegate
  func mapController(_ controller: MZMapViewController, recognizer: UIGestureRecognizer, shouldRecognizeSingleTapGesture location: CGPoint) -> Bool {
    return true
  }


  func mapController(_ controller: MZMapViewController, recognizer: UIGestureRecognizer, didRecognizeSingleTapGesture location: CGPoint) {
    logGesture("Single tap")
  }

  //MARK: MapDoubleTapGestureDelegate
  func mapController(_ controller: MZMapViewController, recognizer: UIGestureRecognizer, shouldRecognizeDoubleTapGesture location: CGPoint) -> Bool {
    return true
  }

  func mapController(_ controller: MZMapViewController, recognizer: UIGestureRecognizer, didRecognizeDoubleTapGesture location: CGPoint) {
    logGesture("Double tap")
  }

  //MARK: MapLongPressGestureDelegate
  func mapController(_ controller: MZMapViewController, recognizer: UIGestureRecognizer, shouldRecognizeLongPressGesture location: CGPoint) -> Bool {
    return true
  }

  func mapController(_ controller: MZMapViewController, recognizer: UIGestureRecognizer, didRecognizeLongPressGesture location: CGPoint) {
    logGesture("Long press")
  }

  //MARK: MapPanGestureDelegate
  func mapController(_ controller: MZMapViewController, didPanMap displacement: CGPoint) {
    logGesture("Pan")
  }

  //MARK: MapPinchGestureDelegate
  func mapController(_ controller: MZMapViewController, didPinchMap location: CGPoint) {
    logGesture("Pinch")
  }

  //MARK: MapRotateGestureDelegate
  func mapController(_ controller: MZMapViewController, didRotateMap location: CGPoint) {
    logGesture("Rotate")
  }

  //MARK: MapShoveGestureDelegate
  func mapController(_ controller: MZMapViewController, didShoveMap displacement: CGPoint) {
    logGesture("Shove")
  }
}
```
