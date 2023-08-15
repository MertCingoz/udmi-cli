#!/usr/bin/env sh
set -o errexit -o nounset

if [ "$1" = "functions" ]; then
  if [ $# -ge 3 ]; then
    gcloud functions logs read --limit="$2" --filter="$3"
  else
    gcloud functions logs read --limit="$2"
  fi
elif [ "$1" = "pubsub" ]; then
  filter="message.attributes.deviceId=$3"
  if [ $# -ge 4 ]; then
    filter="$filter AND message.attributes.subType=$4"
    if [ $# -ge 5 ]; then
      filter="$filter AND message.attributes.subFolder=$5"
    fi
  fi
  gcloud pubsub subscriptions pull "$UDMI_PUBSUB" \
    --format="yaml(message.publishTime, message.attributes, message.data.decode(\"base64\").decode(\"utf-8\"))" \
    --limit="$2" \
    --filter="$filter"
fi
