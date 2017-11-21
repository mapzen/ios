# Location Services
It is extremely easy to show the user's current location on the map. Simply call `MZMapViewController#showCurrentLocation(true)` to display an icon on the map. The iOS SDK also supports visually tracking and centering on the user's current location. To display a button to enable this behavior, call `MZMapViewController#showFindMeButon(true)`.

```swift
import Mapzen-ios-sdk

class LocationExampleViewController:  MZMapViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    try? loadStyleAsync(.bubbleWrap) { [unowned self] (style) in
      _ = self.showCurrentLocation(true)
      _ = self.showFindMeButon(true)
    }
  }
}
```
