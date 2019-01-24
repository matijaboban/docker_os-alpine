## Base image
FROM alpine:3.8

RUN apk update --no-cache
RUN apk upgrade --no-cache

## Run package install script
COPY build/compiled/packages-install.sh /tmp
RUN sh /tmp/packages-install.sh
RUN rm /tmp/packages-install.sh
