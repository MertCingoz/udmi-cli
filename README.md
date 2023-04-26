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
/scripts/register.sh --block
/scripts/register.sh --clean
#/scripts/unregister.sh
#/scripts/unregister.sh "$GOOGLE_CLOUD_REGISTRY"
#/scripts/unregister.sh "$UDMI_ALT_REGISTRY"
```

### Reset Device config
```sh
/scripts/udmi.sh reset_config AHU-1
#/scripts/udmi.sh reset_config MANGO-1
```

### Pubber
```sh
/scripts/udmi.sh pubber AHU-1
#/scripts/udmi.sh pubber AHU-1 extra_field
```

### Validator
```sh
/scripts/udmi.sh validator
```

### Sequencer
```sh
/scripts/udmi.sh sequencer -a AHU-1
#/scripts/udmi.sh sequencer AHU-1
#/scripts/udmi.sh sequencer AHU-1 broken_config

/scripts/udmi.sh sequencer -a MANGO-1
#/scripts/udmi.sh sequencer MANGO-1 empty_enumeration
#/scripts/udmi.sh sequencer MANGO-1 family_enumeration
#/scripts/udmi.sh sequencer MANGO-1 family_ether_addr
#/scripts/udmi.sh sequencer MANGO-1 family_ipv4_addr
#/scripts/udmi.sh sequencer MANGO-1 family_ipv6_addr
#/scripts/udmi.sh sequencer MANGO-1 feature_enumeration
#/scripts/udmi.sh sequencer MANGO-1 multi_enumeration
#/scripts/udmi.sh sequencer MANGO-1 periodic_scan
#/scripts/udmi.sh sequencer MANGO-1 single_scan
```

### Kill pids
```sh
/scripts/udmi.sh kill
```

### Get function logs
```sh
gcloud functions logs read --limit 100
gcloud functions logs read --filter system --limit 100
```
