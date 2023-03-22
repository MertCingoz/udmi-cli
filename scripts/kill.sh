#!/usr/bin/env sh
set -o errexit -o nounset

for process in pubber validator; do
  ps ax | pgrep -af "$process" | grep java | awk '{print $1}' | while read -r pid; do
    kill "$pid"
  done
done
