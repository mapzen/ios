# The Mapzen iOS SDK

The Mapzen iOS SDK is a thin wrapper that packages up everything you need to use Mapzen services in your iOS applications.

We're currently under heavy development with this SDK. We welcome feature requests by posting an issue and labeling it appropriately as an ["Enhancement"](https://github.com/mapzen/ios/issues?q=is%3Aopen+is%3Aissue+label%3Aenhancement). Feel free to also reach out to us using any of the other channels we have available on https://mapzen.com/.

## Usage

At Mapzen we're developing our various SDKs using Xcode 8 and Swift 2.3. However, minor changes are needed to run in Xcode 7 / Swift 2.2. If you need Swift 2.2 support, or you run into any other issues, please open an issue ticket on Github and we'll figure it out together! 

The Mapzen iOS SDK uses Cocoapods to handle importing the various necessary dependencies that underpin our services. The full instructions for installing Cocoapods can be found on https://cocoapods.org/. As of the writing of this document, the Cocoapods installation instructions are diverged as Xcode 8's introduction has made backwards support of Xcode 7 challenging for the Cocoapods maintainers.

When you have installed the appropriate version of Cocoapods for your current development environment, run `pod install` from the command line inside the directory where you cloned this repository. Once that process completes (it can take several minutes depending upon how busy the GitHub servers are that serve Cocoapods), go ahead and open the `ios-sdk.workspace` file container to open the demo application codebase.

## Notes

As noted above, we're currently under heavy development of this SDK. There's a couple of things you should probably know about up front:
* Full Objective-C support is coming soon, see this issue https://github.com/mapzen/ios/issues/68. If you run into issues in your obj-c project, feel free to comment on that issue.
* If you wish to install this to a device, you will need to update the bundle identifier and the code signing in the Xcode project and go through the general code signing process necessary for installing to a device. This will require a free Apple Developer account.
