FROM alpine:3.8

RUN apk update --no-cache
RUN apk upgrade --no-cache

## Run package install script
COPY build/compiled/packages-install.sh /var
RUN sh /var/packages-install.sh
RUN rm /var/packages-install.sh
