# -------- builder stage --------
FROM dhi.io/debian-base:trixie-debian13-dev AS builder

RUN set -euo pipefail; \
    export DEBIAN_FRONTEND=noninteractive; \
    apt-get update && \
    apt-get install -y --no-install-recommends \
      curl wget ca-certificates gnupg dirmngr dpkg-dev && \
    wget -O mullvad-code-signing.asc https://mullvad.net/media/mullvad-code-signing.asc && \
    GNUPGHOME="$(mktemp -d)" && chmod 700 "$GNUPGHOME" && export GNUPGHOME && \
    gpg --batch --import mullvad-code-signing.asc && \
    EXPECTED="A1198702FC3E0A09A9AE5B75D5A1D4F266DE8DDF"; \
    KEY_EMAIL="admin@mullvad.net"; \
    ACTUAL="$(gpg --batch --with-colons --fingerprint "${KEY_EMAIL}" \
      | awk -F: '$1=="fpr" {print $10; exit}' \
      | tr '[:lower:]' '[:upper:]')"; \
    if [ -z "$ACTUAL" ]; then echo "ERROR: fingerprint empty" >&2; exit 1; fi; \
    if [ "$ACTUAL" != "$EXPECTED" ]; then echo "ERROR: fingerprint mismatch" >&2; echo "Expected $EXPECTED, got $ACTUAL" >&2; exit 1; fi; \
    wget --trust-server-names -O deb.sig https://mullvad.net/download/app/deb/latest/signature && \
    curl --fail --show-error --location -o mullvad.deb https://mullvad.net/download/app/deb/latest && \
    gpg --batch --verify deb.sig mullvad.deb && \
    rm -f deb.sig mullvad-code-signing.asc && \
    mkdir -p /staging/root && \
    dpkg-deb -x mullvad.deb /staging/root && \
    rm -f mullvad.deb && \
    rm -rf "$GNUPGHOME" && \
    apt-get purge -y --auto-remove curl wget gnupg dirmngr dpkg-dev ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# -------- final stage (no apt) --------
FROM dhi.io/debian-base:trixie-debian13

COPY --from=builder /staging/root/ /

VOLUME /config

COPY --chmod=0755 *.sh /

ENTRYPOINT ["/entrypoint.sh"]
