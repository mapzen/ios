#!/bin/bash

/usr/libexec/PlistBuddy -c "Set :MAPZEN_API_KEY $MAPZEN_API_KEY" SampleApp/Info.plist
