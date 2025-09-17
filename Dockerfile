FROM debian

RUN apt update && \
    apt install -y curl dbus && \
    curl -L -o mullvad.deb https://mullvad.net/download/app/deb/latest && \
    apt install -y ./mullvad.deb && \
    rm -f mullvad.deb && \
    apt autoclean -y && \
    apt autoremove -y && \
    rm -rf /var/lib/apt/lists/*

VOLUME /config

ADD my_init /
CMD ["/my_init"]