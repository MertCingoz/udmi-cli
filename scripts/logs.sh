#!/usr/bin/env sh
set -o errexit -o nounset

if [ "$1" = "functions" ]; then
  if [ $# -ge 3 ]; then
    gcloud functions logs read --limit="$2" --filter="$3"
  else
    gcloud functions logs read --limit="$2"
  fi
elif [ "$1" = "pubsub" ]; then
  if [ $# -ge 5 ]; then
    gcloud pubsub subscriptions pull udmi_target_subscription \
      --format="yaml(message.publishTime, message.attributes, message.data.decode(\"base64\").decode(\"utf-8\"))" \
      --limit="$2" \
      --filter="message.attributes.deviceId=$3 AND message.attributes.subType=$4 AND message.attributes.subFolder=$5"
  elif [ $# -ge 4 ]; then
    gcloud pubsub subscriptions pull udmi_target_subscription \
        --format="yaml(message.publishTime, message.attributes, message.data.decode(\"base64\").decode(\"utf-8\"))" \
        --limit="$2" \
        --filter="message.attributes.deviceId=$3 AND message.attributes.subType=$4"
  else
    gcloud pubsub subscriptions pull udmi_target_subscription \
        --format="yaml(message.publishTime, message.attributes, message.data.decode(\"base64\").decode(\"utf-8\"))" \
        --limit="$2" \
        --filter="message.attributes.deviceId=$3"
  fi
fi
