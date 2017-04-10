# Search

## Getting Started
Be sure to sign up for an API key as described [here](https://mapzen.com/documentation/ios/getting-started/). After you have a key configured in your app, use the main entry point, `MapzenSearch`, for executing search-related queries.

## Search
Find a place by searching for an address or name.

```swift
private func search() {
  let config = SearchConfig.init(searchText: "pizza") { (response) in
    // display result
  }
  _ = MapzenSearch.sharedInstance.search(config)
}
```

## Autocomplete
Get real-time result suggestions with autocomplete.

```swift
private func autocomplete() {
  let point = GeoPoint.init(latitude: 40.74433, longitude: -73.9903)
  let config = AutocompleteConfig.init(searchText: "pizza", focusPoint: point) { (response) in
    // display result
  }
  _ = MapzenSearch.sharedInstance.autocompleteQuery(config)
}
```

## Reverse
Find what is located at a certain coordinate location.

```swift
private func reverseGeo() {
  let point = GeoPoint.init(latitude: 40.74433, longitude: -73.9903)
  let config = ReverseConfig.init(point: point) { (response) in
    // display result
  }
  _ = MapzenSearch.sharedInstance.reverseGeocode(config)
}
```

## Place
Get rich details about a place.

```swift
private func places() {
  let config = PlaceConfig.init(gids: ["gid", "anotherGid"]) { (response) in
    // display result
  }
  _ = MapzenSearch.sharedInstance.placeQuery(config)
}
```
