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
"$script_dir"/unregister.sh "UDMS-REFLECT"
echo 'Y' | gcloud iot registries delete "$GOOGLE_CLOUD_REGISTRY" --region="$GOOGLE_CLOUD_REGION"
echo 'Y' | gcloud iot registries delete "UDMS-REFLECT" --region="$GOOGLE_CLOUD_REGION"
