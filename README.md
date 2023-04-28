Docker image and instructions to use [UDMI](https://github.com/faucetsdn/udmi) and [required tools](https://faucetsdn.github.io/udmi/docs/tools/) with minimal effort

### Usage
Change docker-compose.yml environment variables for your project  
*GOOGLE_CLOUD_PROJECT*  
*GOOGLE_CLOUD_REGION*  
*GOOGLE_CLOUD_REGISTRY*  
*UDMI_ALT_REGISTRY*  

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
#/scripts/udmi.sh sequencer MANGO-1 writeback_success
#/scripts/udmi.sh sequencer MANGO-1 writeback_invalid
#/scripts/udmi.sh sequencer MANGO-1 writeback_failure
#/scripts/udmi.sh sequencer MANGO-1 valid_serial_no
#/scripts/udmi.sh sequencer MANGO-1 endpoint_connection_success_reconnect
#/scripts/udmi.sh sequencer MANGO-1 endpoint_connection_error
#/scripts/udmi.sh sequencer MANGO-1 endpoint_connection_retry
#/scripts/udmi.sh sequencer MANGO-1 endpoint_connection_bad_hash
#/scripts/udmi.sh sequencer MANGO-1 endpoint_connection_success_alternate
#/scripts/udmi.sh sequencer MANGO-1 endpoint_redirect_and_restart
#/scripts/udmi.sh sequencer MANGO-1 system_mode_restart
#/scripts/udmi.sh sequencer MANGO-1 system_last_update
#/scripts/udmi.sh sequencer MANGO-1 system_min_loglevel
#/scripts/udmi.sh sequencer MANGO-1 device_config_acked
#/scripts/udmi.sh sequencer MANGO-1 broken_config
#/scripts/udmi.sh sequencer MANGO-1 extra_config
#/scripts/udmi.sh sequencer MANGO-1 empty_enumeration
#/scripts/udmi.sh sequencer MANGO-1 pointset_enumeration
#/scripts/udmi.sh sequencer MANGO-1 feature_enumeration
#/scripts/udmi.sh sequencer MANGO-1 family_enumeration
#/scripts/udmi.sh sequencer MANGO-1 multi_enumeration
#/scripts/udmi.sh sequencer MANGO-1 single_scan
#/scripts/udmi.sh sequencer MANGO-1 periodic_scan
#/scripts/udmi.sh sequencer MANGO-1 family_ipv6_addr
#/scripts/udmi.sh sequencer MANGO-1 family_ether_addr
#/scripts/udmi.sh sequencer MANGO-1 family_ipv4_addr
#/scripts/udmi.sh sequencer MANGO-1 pointset_publish_interval
#/scripts/udmi.sh sequencer MANGO-1 pointset_sample_rate
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
