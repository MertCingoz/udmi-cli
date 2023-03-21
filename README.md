Docker image and instructions to use [UDMI](https://github.com/faucetsdn/udmi) tools with minimal effort

### Usage
change docker-compose.yml -> **GOOGLE_CLOUD_PROJECT** environment variable with your project id
```sh
mkdir -p ~/.config
mkdir -p udmi
docker-compose pull
docker-compose up -d --no-build
docker-compose exec tools /bin/bash
```

### UDMI
```sh
/scripts/clone.sh
```

### Gcloud
```sh
/scripts/configure.sh
/scripts/deploy.sh
#/scripts/deploy.sh --firebase
#/scripts/clean.sh
#/scripts/delete.sh
```

### Site model
```sh
/scripts/register.sh
/scripts/register.sh --clean
#/scripts/unregister.sh
#/scripts/unregister.sh "$GOOGLE_CLOUD_REGISTRY"
#/scripts/unregister.sh "$UDMI_ALT_REGISTRY"
```

### Reset Device config
```sh
bin/reset_config sites/udmi_site_model $GOOGLE_CLOUD_PROJECT AHU-1
bin/reset_config sites/udmi_site_model $GOOGLE_CLOUD_PROJECT GAT-123
bin/reset_config sites/udmi_site_model $GOOGLE_CLOUD_PROJECT AHU-22
```

### Pubber
```sh
bin/pubber sites/udmi_site_model $GOOGLE_CLOUD_PROJECT AHU-1 123
bin/pubber sites/udmi_site_model $GOOGLE_CLOUD_PROJECT AHU-1 123 extra_field

bin/pubber sites/udmi_site_model $GOOGLE_CLOUD_PROJECT AHU-22 456
```

### Sequencer
```sh
bin/sequencer -a -v sites/udmi_site_model $GOOGLE_CLOUD_PROJECT AHU-1 123
bin/sequencer -a -v sites/udmi_site_model $GOOGLE_CLOUD_PROJECT AHU-1 123 broken_config

bin/sequencer -a -v sites/udmi_site_model $GOOGLE_CLOUD_PROJECT AHU-22 456
```

### Validator
```sh
bin/validator sites/udmi_site_model $GOOGLE_CLOUD_PROJECT udmi_target_subscription
```

### Integration tests
```sh
bin/test_sequencer $GOOGLE_CLOUD_PROJECT
bin/test_validator $GOOGLE_CLOUD_PROJECT
```

### Kill pids
```sh
/script/kill.sh
```

### Get function logs
```sh
gcloud functions logs read --limit 100
gcloud functions logs read --filter system --limit 100
```
