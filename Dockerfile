ARG base_remote_docker=alpine
ARG base_remote_tag=3.8

FROM ${base_remote_docker}:${base_remote_tag}

RUN apk update --no-cache
RUN apk upgrade --no-cache

## Run package install script
COPY build/compiled/packages-install.sh /var
RUN sh /var/packages-install.sh
RUN rm /var/packages-install.sh
