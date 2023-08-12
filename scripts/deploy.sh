#!/usr/bin/env sh
set -o errexit -o nounset

script_dir=$(dirname "$0")

deployFunctions() {
  udmis/deploy_udmis_gcloud "$GOOGLE_CLOUD_PROJECT"
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
      --public-key path=./sites/udmi_site_model/reflector/rsa_public.pem,type=rsa-pem
}

deployFunctions
createSubscription
createRegistry "$GOOGLE_CLOUD_REGISTRY"
createRegistry "$UDMI_ALT_REGISTRY"
"$script_dir"/register.sh
createReflectRegistry "$UDMI_REFLECT_REGISTRY"
createReflectDevice "$GOOGLE_CLOUD_REGISTRY" "$UDMI_REFLECT_REGISTRY"
createReflectDevice "$UDMI_ALT_REGISTRY" "$UDMI_REFLECT_REGISTRY"
deployFunctions
