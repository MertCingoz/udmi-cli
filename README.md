Docker image and instructions to use [UDMI](https://github.com/faucetsdn/udmi) tools with minimal effort

### Usage
```
change docker-compose.yml -> GOOGLE_CLOUD_PROJECT environment variable with your project id 

mkdir udmi
docker-compose up -d
docker-compose exec tools /bin/bash
```

### Configure gcloud config once
```
gcloud config configurations create udmi-config --activate
gcloud auth login
gcloud auth application-default login
gcloud projects create $GOOGLE_CLOUD_PROJECT
gcloud config set project $GOOGLE_CLOUD_PROJECT

# Create billing account and link to this the project
# https://console.cloud.google.com/billing
# https://console.cloud.google.com/billing/projects

gcloud services enable cloudbuild.googleapis.com cloudfunctions.googleapis.com cloudiot.googleapis.com
```

### Deploy gcloud resources
```
git clone https://github.com/faucetsdn/udmi.git .

dashboard/deploy_dashboard_gcloud $GOOGLE_CLOUD_PROJECT
gcloud pubsub subscriptions create udmi_target_subscription --topic=udmi_target

gcloud iot registries create $GOOGLE_CLOUD_REGISTRY \
    --region=$GOOGLE_CLOUD_REGION \
    --project=$GOOGLE_CLOUD_PROJECT \
    --event-notification-config=topic=udmi_target \
    --state-pubsub-topic=udmi_state
```

### Register test devices
```
bin/clone_model
bin/genkeys sites/udmi_site_model
bin/registrar sites/udmi_site_model $GOOGLE_CLOUD_PROJECT
```

### Deploy reflect resources
```
gcloud iot registries create UDMS-REFLECT \
    --region=$GOOGLE_CLOUD_REGION \
    --project=$GOOGLE_CLOUD_PROJECT \
    --event-notification-config=topic=udmi_reflect

gcloud iot devices create $GOOGLE_CLOUD_REGISTRY \
    --region=$GOOGLE_CLOUD_REGION \
    --project=$GOOGLE_CLOUD_PROJECT \
    --registry=UDMS-REFLECT \
    --public-key path=./sites/udmi_site_model/devices/AHU-1/rsa_public.pem,type=rsa-pem
```

### re-Deploy functions with firebase
```
cd dashboard/functions
npm ci
cd /app

firebase login --no-localhost
dashboard/deploy_dashboard_firebase $GOOGLE_CLOUD_PROJECT
```

### Pubber
```
bin/pubber sites/udmi_site_model $GOOGLE_CLOUD_PROJECT AHU-1 123
bin/pubber sites/udmi_site_model $GOOGLE_CLOUD_PROJECT AHU-1 123 extra_field
bin/pubber sites/udmi_site_model $GOOGLE_CLOUD_PROJECT GAT-123 123
```

### Validator
```
bin/validator sites/udmi_site_model $GOOGLE_CLOUD_PROJECT udmi_target_subscription
```

### Sequencer with pubber
```
bin/test_sequencer $GOOGLE_CLOUD_PROJECT
```

### Sequencer and pubber
```
bin/pubber sites/udmi_site_model $GOOGLE_CLOUD_PROJECT AHU-1 123
bin/sequencer -vv sites/udmi_site_model $GOOGLE_CLOUD_PROJECT AHU-1 123
```

### Clean gcloud resources
```
gcloud functions list | tail -n +2 | awk '{ print $1 }' | while read line; do echo 'Y' | gcloud functions delete $line; done;
gcloud pubsub topics list | grep -o 'projects/.*' | while read line; do gcloud pubsub topics delete $line; done;
gcloud pubsub subscriptions list | grep -o "projects/${GOOGLE_CLOUD_PROJECT}/subscriptions/.*" | while read line; do gcloud pubsub subscriptions delete $line; done;
gcloud iot devices gateways list-bound-devices --gateway=GAT-123 --region=$GOOGLE_CLOUD_REGION --registry=$GOOGLE_CLOUD_REGISTRY | tail -n +2 | awk '{ print $1 }' | while read line; do echo 'Y' | gcloud iot devices gateways unbind --device=$line --gateway=GAT-123 --gateway-region=$GOOGLE_CLOUD_REGION --gateway-registry=$GOOGLE_CLOUD_REGISTRY --device-registry=$GOOGLE_CLOUD_REGISTRY --device-region=$GOOGLE_CLOUD_REGION; done;
gcloud iot devices list --region=$GOOGLE_CLOUD_REGION --registry=$GOOGLE_CLOUD_REGISTRY | tail -n +2 | awk '{ print $1 }' | while read line; do echo 'Y' | gcloud iot devices delete $line --region=$GOOGLE_CLOUD_REGION --registry=$GOOGLE_CLOUD_REGISTRY; done;
gcloud iot devices list --region=$GOOGLE_CLOUD_REGION --registry=UDMS-REFLECT | tail -n +2 | awk '{ print $1 }' | while read line; do echo 'Y' | gcloud iot devices delete $line --region=$GOOGLE_CLOUD_REGION --registry=UDMS-REFLECT; done;
gcloud iot registries list --region=$GOOGLE_CLOUD_REGION | tail -n +2 | awk '{ print $1 }' | while read line; do echo 'Y' | gcloud iot registries delete $line --region=$GOOGLE_CLOUD_REGION; done;
rm -rf * .[^.]*
```
