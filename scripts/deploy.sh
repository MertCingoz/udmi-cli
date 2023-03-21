#!/usr/bin/env sh
set -o errexit -o nounset

script_dir=$(dirname "$0")

deployFunctions() {
  if [ $# -ge 1 ]; then
    curl -sL https://deb.nodesource.com/setup_16.x | bash -
    apt-get update && apt-get --no-install-recommends install -y nodejs
    npm install -g npm@latest firebase-tools
    cd udmis/functions/
    npm install
    firebase login --no-localhost
    firebase projects:list
    firebase projects:addfirebase "$GOOGLE_CLOUD_PROJECT" || true
    firebase use "$GOOGLE_CLOUD_PROJECT"
    firebase deploy --only functions --project "$GOOGLE_CLOUD_PROJECT"
  else
    udmis/deploy_udmis_gcloud "$GOOGLE_CLOUD_PROJECT"
  fi
}

createSubscription() {
  gcloud pubsub subscriptions create udmi_target_subscription --topic=udmi_target
}

createRegistry() {
  gcloud iot registries create "$1" \
      --region="$GOOGLE_CLOUD_REGION" \
      --project="$GOOGLE_CLOUD_PROJECT" \
      --event-notification-config=topic=udmi_target \
      --state-pubsub-topic=udmi_state
}

createReflectRegistry() {
  gcloud iot registries create "$1" \
      --region="$GOOGLE_CLOUD_REGION" \
      --project="$GOOGLE_CLOUD_PROJECT" \
      --event-notification-config=topic=udmi_reflect \
      --state-pubsub-topic=udmi_reflect
}

createReflectDevice() {
  gcloud iot devices create "$1" \
      --region="$GOOGLE_CLOUD_REGION" \
      --project="$GOOGLE_CLOUD_PROJECT" \
      --registry="$2" \
      --public-key path=./sites/udmi_site_model/devices/AHU-1/rsa_public.pem,type=rsa-pem
}

deployFunctions
createSubscription
createRegistry "$GOOGLE_CLOUD_REGISTRY"
createRegistry "$UDMI_ALT_REGISTRY"
"$script_dir"/register.sh
createReflectRegistry "UDMS-REFLECT"
createReflectDevice "$GOOGLE_CLOUD_REGISTRY" "UDMS-REFLECT"
createReflectDevice "$UDMI_ALT_REGISTRY" "UDMS-REFLECT"
deployFunctions
