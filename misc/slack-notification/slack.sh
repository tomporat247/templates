#!/usr/bin/env bash

MESSAGE="Successfully finished running '${ENV0_DEPOLYMENT_TYPE}' deployment on"

if [[ -z "${ENV0_REVIEWER_NAME}" ]]; then
  MESSAGE="${MESSAGE} on repository's default branch.\n"
else
  MESSAGE="${MESSAGE} revision '${REVISION}'.\n"
fi

if [[ -z "${ENV0_REVIEWER_NAME}" ]]; then
  MESSAGE="${MESSAGE} Automatically approved."
else
  MESSAGE="${MESSAGE} Approved by: ${ENV0_REVIEWER_NAME}(${ENV0_REVIEWER_EMAIL})"
fi

PAYLOAD="{\"channel\": \"#notification-test\", \"username\": \"webhookbot\", \"text\": \"${MESSAGE}\", \"icon_emoji\": \":ghost:\"}"

curl -X POST --data-urlencode "payload=${PAYLOAD}" ${SLACK_URL}