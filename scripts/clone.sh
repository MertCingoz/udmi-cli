#!/usr/bin/env sh
set -o errexit -o nounset

git clone --branch "$UDMI_TAG" https://github.com/faucetsdn/udmi.git . || true
git checkout --detach "$UDMI_VERSION"

filePath=validator/src/main/java/com/google/daq/mqtt/validator/ReportingDevice.java
sed 's/previous.before(getThreshold(now))/true/g' "$filePath" | sponge "$filePath"

bin/clone_model
mkdir -p /scripts/udmi_site_model/devices
cp -R /scripts/udmi_site_model sites
bin/genkeys sites/udmi_site_model
