#!/usr/bin/env sh
set -o errexit -o nounset

bin/clone_model
bin/genkeys sites/udmi_site_model
bin/registrar sites/udmi_site_model "$GOOGLE_CLOUD_PROJECT"
