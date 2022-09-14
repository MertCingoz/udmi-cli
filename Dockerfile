FROM google/cloud-sdk:slim

WORKDIR /app

RUN curl -sL https://deb.nodesource.com/setup_12.x  | bash - \
  && apt-get update && apt-get --no-install-recommends install -y \
  jq \
  git \
  nodejs \
  coreutils \
  openjdk-11-jdk \
  && rm -rf /var/lib/apt/lists/* \
  && npm install -g firebase-tools
