#!/usr/bin/env bash
# Runs gcloud as the user from GCP_USER_CREDS, bypassing the session's stand-in token.
set -euo pipefail
dir=$(cd "$(dirname "$0")" && pwd)
CLOUDSDK_AUTH_ACCESS_TOKEN=$("$dir/gcp-token.sh") exec gcloud "$@"
