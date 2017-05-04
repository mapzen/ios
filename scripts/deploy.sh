#!/usr/bin/env bash
#
if [[ ${PERFORM_NIGHTLY} ]]
  then
    fastlane nightly
fi
