Docker image and instructions to use [UDMI](https://github.com/faucetsdn/udmi) and [required tools](https://faucetsdn.github.io/udmi/docs/tools/) with minimal effort

### Usage

#### Change variables in .env file based on your cloud
```
IOT_PROVIDER=
GOOGLE_CLOUD_PROJECT=
GOOGLE_CLOUD_REGION=
GOOGLE_CLOUD_REGISTRY=
UDMI_REFLECTOR_REGISTRY=
UDMI_ALT_REGISTRY=
```

#### Create required folders and connect to docker container

```sh
mkdir -p ~/.config
mkdir -p udmi
docker-compose pull
docker-compose up -d --no-build
docker-compose exec tools /bin/bash
```

### Inside the docker container

#### Clone UDMI project
```sh
/scripts/clone.sh
```

#### Configure gcloud account and deploy required cloud resources 
```sh
/scripts/configure.sh
/scripts/deploy.sh
#/scripts/deploy.sh --firebase
#/scripts/clean.sh
#/scripts/delete.sh
```

### [TOOLS](https://faucetsdn.github.io/udmi/docs/tools/)

#### Site model (Registry operations)
```sh
/scripts/register.sh --block
#/scripts/register.sh --clean
#/scripts/unregister.sh
#/scripts/unregister.sh "$GOOGLE_CLOUD_REGISTRY"
#/scripts/unregister.sh "$UDMI_ALT_REGISTRY"
```

#### Reset Device config (Reset device to registered config)
```sh
/scripts/udmi.sh reset_config AHU-1
#/scripts/udmi.sh reset_config MANGO-1
```

#### Pubber
```sh
/scripts/udmi.sh pubber AHU-1
#/scripts/udmi.sh pubber AHU-1 extra_field
```

#### Validator
```sh
/scripts/udmi.sh validator
```

#### Sequencer
```sh
/scripts/udmi.sh sequencer -a AHU-1
#/scripts/udmi.sh sequencer AHU-1
#/scripts/udmi.sh sequencer AHU-1 broken_config

/scripts/udmi.sh sequencer -a MANGO-1
#/scripts/udmi.sh sequencer MANGO-1 writeback_success
#/scripts/udmi.sh sequencer MANGO-1 writeback_invalid
#/scripts/udmi.sh sequencer MANGO-1 writeback_failure
#/scripts/udmi.sh sequencer MANGO-1 endpoint_connection_error
#/scripts/udmi.sh sequencer MANGO-1 endpoint_connection_retry
#/scripts/udmi.sh sequencer MANGO-1 endpoint_connection_success_reconnect
#/scripts/udmi.sh sequencer MANGO-1 endpoint_connection_bad_hash
#/scripts/udmi.sh sequencer MANGO-1 endpoint_connection_success_alternate
#/scripts/udmi.sh sequencer MANGO-1 endpoint_redirect_and_restart
#/scripts/udmi.sh sequencer MANGO-1 endpoint_failure_and_restart
#/scripts/udmi.sh sequencer MANGO-1 system_mode_restart
#/scripts/udmi.sh sequencer MANGO-1 system_last_update
#/scripts/udmi.sh sequencer MANGO-1 valid_serial_no
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
#/scripts/udmi.sh sequencer MANGO-1 family_ether_addr
#/scripts/udmi.sh sequencer MANGO-1 family_ipv6_addr
#/scripts/udmi.sh sequencer MANGO-1 family_ipv4_addr
#/scripts/udmi.sh sequencer MANGO-1 pointset_publish_interval
#/scripts/udmi.sh sequencer MANGO-1 pointset_remove_point
#/scripts/udmi.sh sequencer MANGO-1 pointset_request_extraneous
#/scripts/udmi.sh sequencer MANGO-1 pointset_sample_rate
```

#### Kill hanging pubber, validator or sequencer processes
```sh
/scripts/udmi.sh kill
```

#### Get function logs from cloud
```sh
/scripts/logs.sh functions 100
/scripts/logs.sh functions 100 system
```

#### Get subscription logs from cloud
```sh
/scripts/logs.sh pubsub 100 MANGO-1
/scripts/logs.sh pubsub 100 MANGO-1 config
/scripts/logs.sh pubsub 100 MANGO-1 config discovery

/scripts/logs.sh pubsub 100 MANGO-1 event
/scripts/logs.sh pubsub 100 MANGO-1 event system

/scripts/logs.sh pubsub 100 MANGO-1 state
/scripts/logs.sh pubsub 100 MANGO-1 state pointset
```

#### Migration tutorial (GCP to ClearBlade)
- https://clearblade.atlassian.net/wiki/spaces/IC/pages/2207449095/Migration+tutorial
- https://github.com/ClearBlade/clearblade-iot-core-migration
- https://clearblade.atlassian.net/wiki/spaces/IC/pages/2210299905/Retargeting+devices
- https://clearblade.atlassian.net/wiki/spaces/IC/pages/2201059341/REST+reference

### TODO
- Check what needs to be done for cloud functions and reflector ? setup for ClearBlade
- validator (registrar, validator, sequencer) seems not working with ClearBlade at this moment
- Update scripts to implement IOT_PROVIDER (ClearBlade) when it is documented
