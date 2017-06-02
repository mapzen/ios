#!/usr/bin/env bash
#
set -o pipefail &&
      xcodebuild
        -sdk iphonesimulator
        -workspace ios-sdk.xcworkspace
        -scheme "ios-sdk"
        -destination 'platform=iOS Simulator,name=iPhone 6,OS=latest'
        MAPZEN_API_KEY=$MAPZEN_API_KEY
        HOCKEY_APP_ID=$HOCKEY_APP_ID
        clean build test |
      tee $CIRCLE_ARTIFACTS/xcode_raw.log |
      xcpretty --color --report junit --output $CIRCLE_TEST_REPORTS/xcode/results.xml