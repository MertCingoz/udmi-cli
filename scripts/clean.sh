#!/usr/bin/env sh
set -o errexit -o nounset

script_dir=$(dirname "$0")

gcloud functions list | tail -n +2 | awk '{ print $1 }' | while read -r function; do
  echo 'Y' | gcloud functions delete "$function"
done

gcloud pubsub topics list | grep -o 'projects/.*' | while read -r topic; do
  gcloud pubsub topics delete "$topic"
done

gcloud pubsub subscriptions list | grep -o "projects/${GOOGLE_CLOUD_PROJECT}/subscriptions/.*" | while read -r subscription; do
  gcloud pubsub subscriptions delete "$subscription"
done

"$script_dir"/unregister.sh "$GOOGLE_CLOUD_REGISTRY"
"$script_dir"/unregister.sh "$UDMI_ALT_REGISTRY"
"$script_dir"/unregister.sh "UDMS-REFLECT"

gcloud iot registries list --region="$GOOGLE_CLOUD_REGION" | tail -n +2 | awk '{ print $1 }' | \
grep -x -e "$GOOGLE_CLOUD_REGISTRY" -e "$UDMI_ALT_REGISTRY" -e "UDMS-REFLECT" | while read -r registry; do
  echo 'Y' | gcloud iot registries delete "$registry" --region="$GOOGLE_CLOUD_REGION"
done
