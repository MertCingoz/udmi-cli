#!/usr/bin/env sh
set -o errexit -o nounset

gcloud functions list | tail -n +2 | awk '{ print $1 }' | while read -r function; do
  echo 'Y' | gcloud functions delete "$function"
done

gcloud pubsub topics list | grep -o 'projects/.*' | while read -r topic; do
  gcloud pubsub topics delete "$topic"
done

gcloud pubsub subscriptions list | grep -o "projects/${GOOGLE_CLOUD_PROJECT}/subscriptions/.*" | while read -r subscription; do
  gcloud pubsub subscriptions delete "$subscription"
done

gcloud iot registries list --region="$GOOGLE_CLOUD_REGION" | tail -n +2 | awk '{ print $1 }' | while read -r registry; do
  gcloud iot devices list --region="$GOOGLE_CLOUD_REGION" --registry="$registry" | tail -n +2 | awk '{ if($3 == "GATEWAY") {print $1 } }' | while read -r gateway; do
    gcloud iot devices gateways list-bound-devices --gateway="$gateway" --region="$GOOGLE_CLOUD_REGION" --registry="$registry" | tail -n +2 | awk '{ print $1 }' | while read -r device; do
        echo 'Y' | gcloud iot devices gateways unbind --device="$device" --gateway="$gateway" --gateway-region="$GOOGLE_CLOUD_REGION" --gateway-registry="$registry" --device-registry="$registry" --device-region="$GOOGLE_CLOUD_REGION"
    done
  done
  gcloud iot devices list --region="$GOOGLE_CLOUD_REGION" --registry="$registry" | tail -n +2 | awk '{ print $1 }' | while read -r device; do
    echo 'Y' | gcloud iot devices delete "$device" --region="$GOOGLE_CLOUD_REGION" --registry="$registry"
  done
  echo 'Y' | gcloud iot registries delete "$registry" --region="$GOOGLE_CLOUD_REGION"
done
