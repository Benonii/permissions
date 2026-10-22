#!/usr/bin/env bash
# Prints a short-lived Google access token minted from GCP_USER_CREDS
# (the authorized_user JSON from `gcloud auth application-default login`).
set -euo pipefail

if [[ -z "${GCP_USER_CREDS:-}" ]]; then
  echo "GCP_USER_CREDS is not set" >&2
  exit 1
fi

resp=$(jq -r '"client_id=\(.client_id)&client_secret=\(.client_secret)&refresh_token=\(.refresh_token)&grant_type=refresh_token"' <<<"$GCP_USER_CREDS" \
  | curl -sS -X POST https://oauth2.googleapis.com/token \
      -H 'Content-Type: application/x-www-form-urlencoded' --data-binary @-)

token=$(jq -r '.access_token // empty' <<<"$resp")
if [[ -z "$token" ]]; then
  echo "Token exchange failed: $(jq -c '{error, error_description}' <<<"$resp")" >&2
  exit 1
fi
echo "$token"
