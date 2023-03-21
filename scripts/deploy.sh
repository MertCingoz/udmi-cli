#!/usr/bin/env sh
set -o errexit -o nounset

dashboard/deploy_dashboard_gcloud "$GOOGLE_CLOUD_PROJECT"
gcloud pubsub subscriptions create udmi_target_subscription --topic=udmi_target

gcloud iot registries create "$GOOGLE_CLOUD_REGISTRY" \
    --region="$GOOGLE_CLOUD_REGION" \
    --project="$GOOGLE_CLOUD_PROJECT" \
    --event-notification-config=topic=udmi_target \
    --state-pubsub-topic=udmi_state

bin/clone_model
bin/genkeys sites/udmi_site_model
bin/registrar sites/udmi_site_model "$GOOGLE_CLOUD_PROJECT"

gcloud iot registries create UDMS-REFLECT \
    --region="$GOOGLE_CLOUD_REGION" \
    --project="$GOOGLE_CLOUD_PROJECT" \
    --event-notification-config=topic=udmi_reflect

gcloud iot devices create "$GOOGLE_CLOUD_REGISTRY" \
    --region="$GOOGLE_CLOUD_REGION" \
    --project="$GOOGLE_CLOUD_PROJECT" \
    --registry=UDMS-REFLECT \
    --public-key path=./sites/udmi_site_model/devices/AHU-1/rsa_public.pem,type=rsa-pem

dashboard/deploy_dashboard_gcloud "$GOOGLE_CLOUD_PROJECT"
