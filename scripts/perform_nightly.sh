#!/bin/bash

if [ -z ${CIRCLE_TOKEN} ]
  then
    echo "[ERROR] CIRCLE_TOKEN environment variable is not set."
    exit 1
fi

trigger_build_url=https://circleci.com/api/v1/project/mapzen/ios/tree/master?circle-token=${CIRCLE_TOKEN}

post_data=$(cat <<EOF
{
  "build_parameters": {
    "PERFORM_NIGHTLY": "true"
  }
}
EOF)

curl \
--header "Accept: application/json" \
--header "Content-Type: application/json" \
--data "${post_data}" \
--request POST ${trigger_build_url}

echo
