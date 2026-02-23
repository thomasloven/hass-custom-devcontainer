#FROM homeassistant/home-assistant:dev
FROM mcr.microsoft.com/devcontainers/python:1-3.13

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN \
    mkdir -p /etc/apt/keyrings \
    && curl -fsSL https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor -o /etc/apt/keyrings/yarn.gpg \
    && echo "deb [signed-by=/etc/apt/keyrings/yarn.gpg] https://dl.yarnpkg.com/debian stable main" > /etc/apt/sources.list.d/yarn.list \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        bluez \
        libffi-dev \
        libssl-dev \
        libjpeg-dev \
        zlib1g-dev \
        autoconf \
        build-essential \
        libopenjp2-7 \
        libtiff6 \
        libturbojpeg0-dev \
        tzdata \
        ffmpeg \
        liblapack3 \
        liblapack-dev \
        libatlas-base-dev \
        \
        git \
        libpcap-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && source /usr/local/share/nvm/nvm.sh \
    && nvm install lts/iron \
    && pip install --upgrade wheel pip

COPY --from=ghcr.io/alexxit/go2rtc:latest /usr/local/bin/go2rtc /bin/go2rtc
RUN pip3 install uv

EXPOSE 8123

VOLUME /config

USER vscode
ENV VIRTUAL_ENV="/home/vscode/.local/ha-venv"
RUN uv venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

COPY requirements.txt /tmp/requirements.txt
RUN uv pip install -r /tmp/requirements.txt
COPY container /usr/bin
COPY hassfest /usr/bin

CMD sudo -E container