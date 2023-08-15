#!/usr/bin/env sh
set -o errexit -o nounset

if [ "$1" = "reset_config" ]; then
  bin/reset_config sites/udmi_site_model "$GOOGLE_CLOUD_PROJECT" "$2"
elif [ "$1" = "pubber" ]; then
    if [ $# -ge 3 ]; then
      bin/pubber sites/udmi_site_model "$GOOGLE_CLOUD_PROJECT" "$2" "$2" "$3"
    else
      bin/pubber sites/udmi_site_model "$GOOGLE_CLOUD_PROJECT" "$2" "$2"
    fi
elif [ "$1" = "validator" ]; then
  bin/validator sites/udmi_site_model "$GOOGLE_CLOUD_PROJECT" "$UDMI_PUBSUB"
elif [ "$1" = "sequencer" ]; then
  if [ "$2" = "-a" ]; then
    bin/sequencer -a -vv sites/udmi_site_model "$GOOGLE_CLOUD_PROJECT" "$3" "$3"
  elif [ $# -ge 3 ]; then
    bin/sequencer -vv sites/udmi_site_model "$GOOGLE_CLOUD_PROJECT" "$2" "$2" "$3"
  else
    bin/sequencer -vv sites/udmi_site_model "$GOOGLE_CLOUD_PROJECT" "$2" "$2"
  fi
elif [ "$1" = "kill" ]; then
  for process in pubber validator; do
    ps ax | pgrep -af "$process" | grep java | awk '{print $1}' | while read -r pid; do
      kill "$pid"
    done
  done
fi
