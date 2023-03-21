#!/usr/bin/env sh
set -o errexit -o nounset

registry="${1:-$GOOGLE_CLOUD_REGISTRY}"

gcloud iot devices list --region="$GOOGLE_CLOUD_REGION" --registry="$registry" | tail -n +2 | awk '{ if($3 == "GATEWAY") {print $1 } }' | while read -r gateway; do
  gcloud iot devices gateways list-bound-devices --gateway="$gateway" --region="$GOOGLE_CLOUD_REGION" --registry="$registry" | tail -n +2 | awk '{ print $1 }' | while read -r device; do
      echo 'Y' | gcloud iot devices gateways unbind --device="$device" --gateway="$gateway" --gateway-region="$GOOGLE_CLOUD_REGION" --gateway-registry="$registry" --device-registry="$registry" --device-region="$GOOGLE_CLOUD_REGION"
  done
done

gcloud iot devices list --region="$GOOGLE_CLOUD_REGION" --registry="$registry" | tail -n +2 | awk '{ print $1 }' | while read -r device; do
  echo 'Y' | gcloud iot devices delete "$device" --region="$GOOGLE_CLOUD_REGION" --registry="$registry"
done
