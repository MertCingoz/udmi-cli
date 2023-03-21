#!/usr/bin/env sh
set -o errexit -o nounset

git clone --branch "$UDMI_TAG" https://github.com/faucetsdn/udmi.git . || true
git checkout --detach "$UDMI_VERSION"
sed 's/= getDefaultInterface()/= "eth0"/g' pubber/src/main/java/daq/pubber/LocalnetManager.java > tmp
mv tmp pubber/src/main/java/daq/pubber/LocalnetManager.java
bin/clone_model
bin/genkeys sites/udmi_site_model
