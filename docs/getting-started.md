# Getting started

## 1. Sign up for an API key
Sign up for an API key from the [Mapzen developer portal](https://mapzen.com/documentation/overview/). Then, use it in the App Delegate's `applicationDidFinishLaunching:`:

```swift
import Mapzen-ios-sdk
---- Inside your applicationDidFinishLaunching() ----
MapzenManager.sharedManager.apiKey = "your-mapzen-api-key"
```

## 2. Add a map to your storyboard
Adding a Mapzen map to your storyboard is as easy as:

1. Drag a standard UIViewController onto your storyboard canvas.
2. Create a subclass file named, for example: `DemoMapViewController` and set its super class to be `MZMapViewController`.
3. Back, in the storyboard, change the UIViewController's subclass to be `DemoMapViewController`.

## 3. Initialize the map
Override `viewDidLoad()` in `DemoMapViewController`'s implementation and instruct it to load a map style like so:
```swift
_ = try? loadStyleAsync(.bubbleWrap) { [unowned self] (style) in
  // the map is now ready for interaction
}
```
This will load the house style [Bubble Wrap](https://github.com/tangrams/bubble-wrap) that's packaged with the SDK.


Your map is now ready to use.

For advanced use (animations, custom styles, etc.) please refer to the [Tangram ES](https://github.com/tangrams/tangram-es) documentation.
