# -------- builder stage --------
FROM dhi.io/debian-base:trixie-debian13-dev AS builder

RUN set -euo pipefail; \
    export DEBIAN_FRONTEND=noninteractive; \
    apt-get update && \
    apt-get install -y --no-install-recommends \
      curl wget ca-certificates gnupg dirmngr dpkg-dev binutils && \
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
    # Install runtime deps needed by mullvad-daemon (incl. libdbus-1-3), then copy them into /staging/root.
    # This also copies dbus package files and one level of transitive shared-library deps so libdbus can be loaded in the final image.
    apt-get install -y --no-install-recommends libdbus-1-3 && \
    ( \
      set -e; \
      dpkg -L libdbus-1-3 | grep -E '^/(lib|usr/lib|etc|usr/share)' | sort -u > /tmp/libdbus_files.txt; \
      while IFS= read -r path; do \
        [ -e "$path" ] || continue; \
        mkdir -p "/staging/root$(dirname "$path")"; \
        cp -a "$path" "/staging/root$path"; \
      done < /tmp/libdbus_files.txt; \
      DAEMON_PATH="$(find /staging/root -type f -name 'mullvad-daemon' 2>/dev/null | head -n1 || true)"; \
      if [ -n "$DAEMON_PATH" ]; then \
        ldd "$DAEMON_PATH" | awk '{print $3}' | grep -E '^/.*\\.so(\\.|$)|^/.*ld-linux' | sort -u > /tmp/mullvad_libs.txt; \
        while IFS= read -r lib; do \
          [ -f "$lib" ] || continue; \
          ldd "$lib" | awk '{print $3}' | grep -E '^/.*\\.so(\\.|$)|^/.*ld-linux' || true; \
        done < /tmp/mullvad_libs.txt | sort -u > /tmp/mullvad_libs_deps.txt; \
        cat /tmp/mullvad_libs.txt /tmp/mullvad_libs_deps.txt | sort -u > /tmp/mullvad_libs_all.txt; \
        while IFS= read -r lib; do \
          [ -f "$lib" ] || continue; \
          mkdir -p "/staging/root$(dirname "$lib")"; \
          cp -a "$lib" "/staging/root$lib"; \
        done < /tmp/mullvad_libs_all.txt; \
      fi; \
    ) && \
    mkdir -p /staging/root/var/log/mullvad-vpn && chmod 0777 /staging/root/var/log/mullvad-vpn && \
    apt-get purge -y --auto-remove curl wget gnupg dirmngr dpkg-dev ca-certificates gnupg-utils && \
    rm -rf /var/lib/apt/lists/*

# -------- final stage (no apt) --------
FROM dhi.io/debian-base:trixie-debian13

COPY --from=builder /staging/root/ /
COPY --from=builder --chmod=0777 /staging/root/var/log/mullvad-vpn /var/log/mullvad-vpn

VOLUME /config

COPY --chmod=0755 *.sh /

ENTRYPOINT ["/entrypoint.sh"]