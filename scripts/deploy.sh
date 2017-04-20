#!/usr/bin/env bash
#
if [[ ${PERFORM_NIGHTLY} ]]
  then
    ipa distribute:hockeyapp --file "$CIRCLE_ARTIFACTS/ios-sdk.ipa" --dsym "$CIRCLE_ARTIFACTS/ios-sdk.app.dSYM.zip" --teams "$NIGHTLY_SAMPLE_TEAM_ID" --notify --token "$HOCKEYAPP_TOKEN" --markdown --notes "CircleCI build $CIRCLE_BUILD_NUM" --commit-sha "$CIRCLE_SHA1" --build-server-url "$CIRCLE_BUILD_URL" --repository-url "$CIRCLE_REPOSITORY_URL"
fi
