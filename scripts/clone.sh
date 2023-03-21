#!/usr/bin/env sh
set -o errexit -o nounset

git clone --branch "$UDMI_TAG" https://github.com/faucetsdn/udmi.git . || true
git checkout --detach "$UDMI_VERSION"
