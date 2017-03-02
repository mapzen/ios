# Mapzen iOS SDK Release Checklist

## Requirements
- Have Xcode installed
- Have cocoapods installed
- Have ownership privileges to update the cocoapods trunk spec

## Steps
1. Tag current master with the version you want to release, and push to github.
2. Update the Mapzen-ios-sdk.podspec version number property with that same tag
3. Update the .swift file with the current version of swift the sdk is compiled against
4. Run `pod spec lint` to make sure everything is happy. Fix issues if not happy (eventually we should document known possible issues). Submit to PR once lint is clean.
3. Once #2 PR merges, push the updated pod spec to trunk: `pod trunk push Mapzen-ios-sdk.podspec`
4. Write up release notes and release the SDK on github.
