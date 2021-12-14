FROM ubuntu:latest

ENV REVIEWDOG_VERSION=v0.13.0

RUN apt-get update -y

# Install wget
RUN apt-get install wget -y

# Install and upgrade pip
RUN apt install python3-pip -y
RUN python3 -m pip install --upgrade pip

# Install reviewdog, flake8 and flakehell
RUN python3 -m pip install --no-cache-dir flake8==3.9.2 flakehell==0.3.3

RUN wget -O - -q https://raw.githubusercontent.com/reviewdog/reviewdog/master/install.sh \
    | sh -s -- -b /usr/local/bin/ ${REVIEWDOG_VERSION}

# COPY pyproject.toml /pyproject.toml
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
