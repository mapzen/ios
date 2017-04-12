# The Mapzen iOS SDK
[![Circle CI](https://circleci.com/gh/mapzen/ios.svg?style=shield&circle-token=158f79f566b88fb913ad153ee8b00681112eb5a2)](https://circleci.com/gh/mapzen/ios)

<p align=center>
<img width="311" height="552" src="https://mapzen-assets.s3.amazonaws.com/images/ios-sdk-beta/sdk-beta-map.png">
</p>

The Mapzen iOS SDK is a thin wrapper that packages up everything you need to use Mapzen services in your iOS applications.

We recently released our beta version of the SDK, version 0.2.0. The API at this point is fairly stable and we'd welcome feedback from the community on its usage. Feature requests are also welcome; label it appropriately as an ["Enhancement"](https://github.com/mapzen/ios/issues?q=is%3Aopen+is%3Aissue+label%3Aenhancement) and be aware we probably won't be able to implement it until after launch at this point. Feel free to also reach out to us using any of the other channels we have available on https://mapzen.com/.

## Usage
Everything you need to get going using the Mapzen SDK

### Set up
- [Installation](https://github.com/mapzen/ios/blob/master/docs/installation.md)
- [Getting started](https://github.com/mapzen/ios/blob/master/docs/getting-started.md)

### Interacting with the map
- [Position, rotation, zoom, and tilt](https://github.com/mapzen/ios/blob/master/docs/basic-functions.md)
- [Markers, polylines, and polygons](https://github.com/mapzen/ios/blob/master/docs/features.md)
- [Switching styles](https://github.com/mapzen/ios/blob/master/docs/styles.md)
- [Gesture delegates](https://github.com/mapzen/ios/blob/master/docs/gesture-delegates.md)
- [Current location](https://github.com/mapzen/ios/blob/master/docs/location-services.md)

### Search and routing
- [Search](https://github.com/mapzen/ios/blob/master/docs/search.md)
- [Routing](https://github.com/mapzen/ios/blob/master/docs/turn-by-turn.md)


# What's Included

Version 1.0 of our iOS SDK will be nearly at feature parity with our well established [Android SDK](https://github.com/mapzen/android).

Major features include:
* High performance and highly customizable map rendering using OpenGL ES provided by [Tangram-es](https://github.com/tangrams/tangram-es).
* Driving directions and customizable route lines provided by [Mapzen Turn-by-Turn](https://mapzen.com/products/turn-by-turn/).
* Geocoding and Point-of-Interest search provided by [Mapzen Search](https://mapzen.com/products/search/).
* Several [base map styles](https://mapzen.com/products/maps/) to suit most use cases.

And many more features than we can list here in a timely fashion.

# How Do I Get The SDK?

Step 1: Get yourself a free [Mapzen API Key](https://mapzen.com/developers/sign_up).

Step 2: Install the beta SDK through [Cocoapods](https://cocoapods.org/pods/Mapzen-ios-sdk).

Step 3: Check out the sample app [source code](https://github.com/mapzen/ios/tree/master/SampleApp) or `pod try Mapzen-ios-sdk` to load it immediately. You'll need that API key from step 1 in either case. See where to set it [below](#configure-api-key).

Step 4: Let us know your thoughts! You can either open a [new issue on GitHub](https://github.com/mapzen/ios/issues) or send us email at ios-support@mapzen.com.

## Non-Cocoapods Usage

Non-cocoapods usage at this point is not recommended, but can be accomplished. First, make sure to `git submodule update --init --recursive` to get all the style sheets after cloning this repository. Second. you will need to include the 3 other dependencies we require: [Tangram-es](https://github.com/tangrams/ios-framework), [OnTheRoad for iOS](https://github.com/mapzen/on-the-road_ios), and the [Pelias iOS SDK](https://github.com/pelias/pelias-ios-sdk). Note that your project will need to support Swift 3.

## Notes
There's a couple of things you should probably know about up front:
* We only will be supporting Swift 3.0 moving forward. Older versions of the SDK were written in Swift 2, but it is not recommended to use that as the project has changed dramatically since then, and we're continuing to add features all the time.
* If you wish to install the sample app to a device (recommended due to performance issues in the simulator), you will need to update the bundle identifier and the code signing in the Xcode project and go through the general code signing process necessary for installing to a device. This will require a free Apple Developer account.

## Configure Api Key
There are two ways to set your API key in the Sample App:

1. Update SampleApp/Info.plist

Replace `$(MAPZEN_API_KEY)` with your key:

<p align=center>
<img width="765" height="291" src="https://mapzen-assets.s3.amazonaws.com/images/ios-sdk-beta/info_plist.png">
</p>

-- OR --

2. Create a new scheme and add an environment variable

Duplicate the `ios-sdk` scheme and then add your environment variable here:

<p align=center>
<img width="571" height="325" src="https://mapzen-assets.s3.amazonaws.com/images/ios-sdk-beta/custom_scheme.png">
</p>
