FROM ubuntu:18.04

ENV REVIEWDOG_VERSION=v0.13.0

RUN apt-get update -y

# Get rid of existing python and pip installations.
RUN apt-get purge python3.? python3-pip -y && apt-get clean || :

# Install wget
RUN apt-get install --no-install-recommends wget git -y

# Install python3.7 and pip
RUN apt-get update && apt-get install -y --no-install-recommends \
        software-properties-common
RUN add-apt-repository ppa:deadsnakes/ppa -y
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3.7 \
    python3-pip
RUN python3.7 -m pip install --no-cache-dir --upgrade pip
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3-distutils \
    python3-setuptools

# Clean up apt-get
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install reviewdog, flake8, pylint and flakehell, then plugins for flakehell
# flake8 has a bug in versions>3.9.0 https://github.com/flakehell/flakehell/issues/10
# and another in >4.0.0 https://github.com/flakehell/flakehell/issues/22
RUN python3.7 -m pip install --no-cache-dir \
    flake8==3.9.2 \
    flakehell==0.9.0 \
    pylint==2.12.2 \
    flake8-bugbear \
    flake8-comprehensions \
    flake8-return \
    flake8-simplify \
    flake8-spellcheck \
    flake8-functions \
    wemake-python-styleguide \
    flake8-markdown \
    flake8-docstrings \
    flake8-codes \
    flake8-import-order

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN wget -O - -q https://raw.githubusercontent.com/reviewdog/reviewdog/master/install.sh \
    | sh -s -- -b /usr/local/bin/ ${REVIEWDOG_VERSION}

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
