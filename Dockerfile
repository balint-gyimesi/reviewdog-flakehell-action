FROM ubuntu:18.04

ENV REVIEWDOG_VERSION=v0.13.0

RUN apt-get update -y

# Install wget
RUN apt-get install --no-install-recommends wget git -y

# Install and upgrade pip
RUN apt-get install python3-pip -y
RUN python3 -m pip install --no-cache-dir --upgrade pip

# Clean up apt-get
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install reviewdog, flake8, pylint and flakehell
# flake8 has a bug in versions>3.9.0 https://github.com/flakehell/flakehell/issues/10
RUN python3 -m pip install --no-cache-dir flake8==3.9.0 flakehell==0.8.0 pylint==2.6.0

# Install plugins for flakehell
RUN python3 -m pip install --no-cache-dir \
    flake8-bugbear \
    flake8-comprehensions \
    flake8-return \
    flake8-simplify \
    flake8-spellcheck \
    # flake8-functions has a bug at least on python3.6.9
    # flake8-functions \
    # Enable this once we're ready
    # wemake-python-styleguide \
    flake8-markdown \
    flake8-docstrings \
    flake8-codes \
    flake8-import-orderhttps://github.com/berkshiregrey/bg_devinfra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


RUN wget -O - -q https://raw.githubusercontent.com/reviewdog/reviewdog/master/install.sh \
    | sh -s -- -b /usr/local/bin/ ${REVIEWDOG_VERSION}

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
# For local testing
# ENTRYPOINT [ "/bin/bash" ]
