FROM ubuntu:18.04

ENV REVIEWDOG_VERSION=v0.13.0

RUN apt-get update -y

# Install wget
RUN apt-get install -no-install-recommends wget -y

# Install and upgrade pip
RUN apt-get install python3-pip -y
RUN python3 -m pip install --no-cache-dir --upgrade pip

# Clean up apt-get
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install reviewdog, flake8 and flakehell
# flake8 has a bug in versions>3.9.0 https://github.com/flakehell/flakehell/issues/10
RUN python3 -m pip install --no-cache-dir flake8==3.9.0 flakehell==0.8.0

RUN wget -O - -q https://raw.githubusercontent.com/reviewdog/reviewdog/master/install.sh \
    | sh -s -- -b /usr/local/bin/ ${REVIEWDOG_VERSION}

# COPY pyproject.toml /pyproject.toml
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
