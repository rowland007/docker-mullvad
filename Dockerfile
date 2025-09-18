FROM debian:stable-slim

RUN set -ex; \
    apt update && \
    apt upgrade -y && \
    apt install -y curl dbus && \
    curl -L -o mullvad.deb https://mullvad.net/download/app/deb/latest && \
    apt install -y ./mullvad.deb && \
    rm -f mullvad.deb && \
    apt autoclean -y && \
    apt autoremove -y && \
    rm -rf /var/lib/apt/lists/*

VOLUME /config

COPY *.sh /

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
