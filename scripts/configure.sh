#!/usr/bin/env sh
set -o errexit -o nounset

gcloud config configurations create udmi-config --activate || gcloud config configurations activate udmi-config
gcloud auth login
gcloud auth application-default login
gcloud projects describe "$GOOGLE_CLOUD_PROJECT" || gcloud projects create "$GOOGLE_CLOUD_PROJECT"
gcloud config set project "$GOOGLE_CLOUD_PROJECT"

billingUrl=https://console.cloud.google.com/billing
printf "\nCreate billing account -> %s\n" "$billingUrl"
printf "Press enter to continue"
read -r _key
printf "\nLink billing account to project:%s -> %s/projects\n" "$GOOGLE_CLOUD_PROJECT" "$billingUrl"
printf "Press enter to continue"
read -r _key

gcloud services enable cloudbuild.googleapis.com cloudfunctions.googleapis.com cloudiot.googleapis.com
