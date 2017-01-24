# Getting started

## 1. Sign up for an API key
Sign up for an API key from the [Mapzen developer portal](https://mapzen.com/developers). Then, insert the API key in your App Delegate's `applicationDidFinishLaunching:` like so:

```swift
MapzenManager.sharedManager.apiKey = "API_KEY_HERE"
```

## 2. Add a map to your storyboard
Adding a Mapzen map to your storyboard is as easy as:

1. Drag a GLKitViewController onto your storyboard canvas
2. Create a subclass file named, for example: `MapVC` and set it's super class to be `MapViewController`
3. Back, in the storyboard, change the GLKitViewController's subclass to be `MapVC`

## 3. Initialize the map
Override `viewDidLoad()` in `MapVC`'s implementation and instruct it to load a scene file like so: 
```swift
let _ = try? loadScene("scene.yaml")
```
This will load the default scene file [Bubble Wrap])(https://github.com/tangrams/bubble-wrap) that's packaged with the SDK


Your map is now ready to use.

For advanced use (animations, custom styles, etc.) please refer to the [Tangram ES](https://github.com/tangrams/tangram-es) documentation.