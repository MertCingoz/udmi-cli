FROM gcr.io/google.com/cloudsdktool/google-cloud-cli:alpine

WORKDIR /app

RUN apk add --no-cache jq moreutils openjdk17
