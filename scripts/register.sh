#!/usr/bin/env bash
set -o errexit -o nounset

if [ $# -ge 1 ]; then
  if [ "$1" = "--clean" ]; then
    script_dir=$(dirname "$0")
    "$script_dir"/unregister.sh "$GOOGLE_CLOUD_REGISTRY"
    "$script_dir"/unregister.sh "$UDMI_ALT_REGISTRY"
  fi
fi

site=sites/udmi_site_model
bin/clone_model
mkdir -p /scripts/udmi_site_model/devices
cp -R /scripts/udmi_site_model sites
bin/genkeys "$site"
bin/registrar "$site" "$GOOGLE_CLOUD_PROJECT"

alternate="$site"_alternate
rm -rf "$alternate"
mkdir -p "$alternate"
cp -r "$site"/* "$alternate"
cat <<< "$(jq ".registry_id = \"$UDMI_ALT_REGISTRY\"" "$alternate"/cloud_iot_config.json)" > "$alternate"/cloud_iot_config.json
bin/registrar "$alternate" "$GOOGLE_CLOUD_PROJECT"

#bin/sequencer "$site" "$GOOGLE_CLOUD_PROJECT" AHU-1 123 no_valid_test || true
#validator/bin/registrar /tmp/validator_config.json
#validator/bin/registrar /tmp/validator_config.json -a
