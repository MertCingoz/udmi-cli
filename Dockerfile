FROM google/cloud-sdk:slim

WORKDIR /app

RUN apt-get update && apt-get --no-install-recommends install -y \
  jq \
  git \
  procps \
  coreutils \
  openjdk-11-jdk \
  && rm -rf /var/lib/apt/lists/*
