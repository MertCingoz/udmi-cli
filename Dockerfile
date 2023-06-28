FROM google/cloud-sdk:slim

WORKDIR /app

RUN apt-get update && apt-get --no-install-recommends install -y \
  jq \
  git \
  procps \
  iproute2 \
  coreutils \
  openjdk-17-jdk-headless \
  && rm -rf /var/lib/apt/lists/*
