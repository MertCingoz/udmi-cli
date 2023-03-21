#!/usr/bin/env sh
set -o errexit -o nounset

(echo 'Y' | gcloud projects delete "$GOOGLE_CLOUD_PROJECT") || true
rm -rf ./* .[!.]*
