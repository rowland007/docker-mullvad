FROM dhi.io/debian-base:trixie

RUN set -ex; \
    apt-get update && \
    apt-get install -y curl dbus && \
    curl -L -o mullvad.deb https://mullvad.net/download/app/deb/latest && \
    apt install -y ./mullvad.deb && \
    rm -f mullvad.deb \
    apt-get purge -y curl

VOLUME /config

COPY *.sh /

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
