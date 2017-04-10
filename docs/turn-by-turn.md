# Turn-by-Turn

## Getting Started
Be sure to sign up for an API key as described [here](https://mapzen.com/documentation/ios/getting-started/). After you have a key configured in your app, use the main entry point, `RoutingController`, for executing turn-by-turn queries.

## Fetch Route
To fetch a route you need to give the router a list of locations and a costing model at minimum. The first and last locations must be "break" points. To configure costing options see the turn-by-turn [costing options documentation](https://mapzen.com/documentation/mobility/turn-by-turn/api-reference/#costing-options) for available parameters. And, to configure directions options such as the units, see the [directions options documentation](https://mapzen.com/documentation/mobility/turn-by-turn/api-reference/#directions-options).

```swift
let router = try? RoutingController.controller()
let locations = [
  OTRRoutingPoint.init(coordinate: OTRGeoPoint.init(latitude: 40.74433, longitude: -73.9903), type: .break),
  OTRRoutingPoint.init(coordinate: OTRGeoPoint.init(latitude: 40.734807, longitude: -73.984770), type: .through),
  OTRRoutingPoint.init(coordinate: OTRGeoPoint.init(latitude: 40.732172, longitude: -73.998674), type: .through),
  OTRRoutingPoint.init(coordinate: OTRGeoPoint.init(latitude: 40.741050, longitude: -73.996142), type: .break)
]
_ = router?.requestRoute(withLocations: locations, costingModel: .auto, costingOption: nil, directionsOptions: nil) { (result, asd, error) in
  //
}
```
