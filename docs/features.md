# Add features to a map

The iOS SDK offers ways to add various feature overlays to a map as markers (points), polygons, and polylines.

## Markers
There are three different marker classes: `PointMarker`, `SystemPointMarker`, and `SelectableSystemPointMarker`. Use `PointMarker` for markers with either a custom background color or image. Use `SystemPointMarker` for items such as a current location indicator, route location arrow, or dropped pin. If you would like selectable system markers, use `SelectableSystemPointMarker` for search and route start & end pins. Add the marker to the map by calling `MZMapViewController#addMarker(GenericMarker)`.

```swift
import Foundation
import TangramMap

class FeatureExampleViewController:  MZMapViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    _ = try? loadStyleAsync(.bubbleWrap) { [unowned self] (style) in
      self.position = TGGeoPointMake(-73.9908, 40.73711)
      self.zoom = 14
      self.addMarkers()
    }
  }

  fileprivate func addMarkers() {
    let pointMarker = PointMarker.init(size: CGSize(width: 30, height: 30))
    pointMarker.icon = UIImage.init(named: "logo")
    pointMarker.backgroundColor = UIColor.purple
    pointMarker.point = TGGeoPointMake(-73.9903, 40.74433)
    self.addMarker(pointMarker);

    let systemMarker = SystemPointMarker.init(markerType: .currentLocation)
    systemMarker.point = TGGeoPointMake(-73.984770, 40.734807)
    self.addMarker(systemMarker);

    let selectableSystemMarker = SelectableSystemPointMarker.init(markerType: .searchPin)
    selectableSystemMarker.point = TGGeoPointMake(-73.998674, 40.732172)
    self.addMarker(selectableSystemMarker);
  }
}
```

## Polygons
To add a polygon to the map, create a `TGGeoPolygon` and add points to it. Then create a `PolygonMarker`, set its polygon to be the one you created above and call `MZMapViewController#addMarker(PolygonMarker)`.

```swift
import Foundation
import TangramMap

class FeatureExampleViewController:  MZMapViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    _ = try? loadStyleAsync(.bubbleWrap) { [unowned self] (style) in
      self.position = TGGeoPointMake(-73.9908, 40.73711)
      self.zoom = 14
      self.addPolygon()
    }
  }

  fileprivate func addPolygon() {
    let polygon = TGGeoPolygon.init()
    polygon.startPath(TGGeoPointMake(-73.9903, 40.74433))
    polygon.add(TGGeoPointMake(-73.984770, 40.734807))
    polygon.add(TGGeoPointMake(-73.998674, 40.732172))
    polygon.add(TGGeoPointMake(-73.996142, 40.741050))
    let marker = PolygonMarker.init()
    marker.polygon = polygon
    marker.backgroundColor = UIColor.green
    self.addMarker(marker)
  }

}
```

## Polylines
To add a polyline to the map, create a `TGGeoPolyline` and add points to it. Then create a `PolylineMarker`, set its polyline to be the one you created above and call `MZMapViewController#addMarker(PolylineMarker)`.

```swift
import Foundation
import TangramMap

class FeatureExampleViewController:  MZMapViewController {

  override func viewDidLoad() {
   super.viewDidLoad()
   _ = try? loadStyleAsync(.bubbleWrap) { [unowned self] (style) in
     self.position = TGGeoPointMake(-73.9908, 40.73711)
     self.zoom = 14
     self.addPolyline()
   }
 }

 fileprivate func addPolyline() {
   let polyline = TGGeoPolyline.init()
   polyline.add(TGGeoPointMake(-73.9903, 40.74433))
   polyline.add(TGGeoPointMake(-73.984770, 40.734807))
   polyline.add(TGGeoPointMake(-73.998674, 40.732172))
   polyline.add(TGGeoPointMake(-73.996142, 40.741050))
   let marker = PolylineMarker.init()
   marker.polyline = polyline
   marker.backgroundColor = UIColor.blue
   self.addMarker(marker)
 }

}
```
