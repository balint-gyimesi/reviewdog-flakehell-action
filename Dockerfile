FROM ubuntu:latest

ENV REVIEWDOG_VERSION=v0.13.0

SHELL ["/bin/sh", "-eo", "pipefail", "-c"]

# hadolint ignore=DL3006
RUN apk --no-cache add git

# Install python 3.7 and pip
# RUN apt install python3.7 -y
# RUN apt install python3-pip -y
# RUN python3 -m pip install --upgrade pip

RUN wget -O - -q https://raw.githubusercontent.com/reviewdog/reviewdog/master/install.sh| sh -s -- -b /usr/local/bin/ ${REVIEWDOG_VERSION}

RUN python3 -m pip install --no-cache-dir flake8=4.0.1 flakehell=0.3.3

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
