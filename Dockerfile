FROM dhi.io/debian-base:trixie-debian13-dev

RUN set -ex; \
    apt update && \
    apt install -y curl dbus && \
    curl -L -o mullvad.deb https://mullvad.net/download/app/deb/latest && \
    apt install -y ./mullvad.deb && \
    apt purge -y curl; \
    apt autoremove -y; \
    apt autoclean -y; \
    rm -rf mullvad.deb /var/lib/apt/lists/*

VOLUME /config

COPY *.sh /

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
