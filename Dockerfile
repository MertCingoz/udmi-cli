FROM azul/zulu-openjdk-alpine:17
ADD bin/ bin/

RUN apk add --no-cache jq moreutils bash git openssh-client python3 \
    && python3 -m venv venv \
    && . ./venv/bin/activate \
    && pip3 install Jinja2

WORKDIR /udmi
