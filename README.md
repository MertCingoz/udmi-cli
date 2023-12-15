Docker image and instructions to use [UDMI](https://github.com/faucetsdn/udmi) and [required tools](https://faucetsdn.github.io/udmi/docs/tools/) with minimal effort

### Usage

#### Change variables in .env file based on your cloud
```
UDMI_REPO=
UDMI_VERSION=
UDMI_REGISTRY=
UDMI_MODEL_REPO=
```

#### Create required folders and connect to docker container

```sh
mkdir -p udmi
docker-compose up -d --no-build --pull=always
docker-compose exec tools /bin/bash
```

### Inside the docker container

```sh
udmi clone

udmi registrar 
udmi device AHU-1
udmi device AHU-1 serial-1234
udmi pubber
udmi pubber badVersion
udmi sequencer
udmi sequencer -a
udmi sequencer broken_config
```
