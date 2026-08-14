FROM ubuntu:26.04 AS download

ARG DEBIAN_FRONTEND=noninteractive
ARG FLAMESHOT_URL=https://github.com/flameshot-org/flameshot/releases/download/v14.0.0/flameshot-v14.0%2Bgit0.da6121bd-artifact-debian-12-amd64.zip
ARG FLAMESHOT_SHA256=f8846eba71a8c093594792fa51e3aed7459b46298762316e476ff0948bf66845

RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates curl unzip && \
    curl -fL "$FLAMESHOT_URL" -o /tmp/flameshot.zip && \
    echo "$FLAMESHOT_SHA256  /tmp/flameshot.zip" | sha256sum -c - && \
    unzip /tmp/flameshot.zip -d /tmp/flameshot

FROM ghcr.io/containerpak/gtk3:main

ARG DEBIAN_FRONTEND=noninteractive

RUN --mount=type=bind,from=download,source=/tmp/flameshot/flameshot-14.0.0-1.debian-12.amd64.deb,target=/run/flameshot.deb \
    apt-get update && \
    apt-get install -y --no-install-recommends /run/flameshot.deb grim && \
    cpak-clean-junk
