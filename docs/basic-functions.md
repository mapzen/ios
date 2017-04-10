# Position, rotation, zoom, and tilt

When the map style finishes loading, your `OnStyleLoaded` closure will be executed and you can begin to manipulate the map. Set the position, rotation, zoom, and tilt as follows:

```swift
import Foundation
import TangramMap

class PositionExampleViewController:  MZMapViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    _ = try? loadStyleAsync(.bubbleWrap) { [unowned self] (style) in
      self.position = TGGeoPointMake(-73.9903, 40.74433)
      self.rotation = 0
      self.zoom = 17
      self.tilt = 0
    }
  }

}
```
