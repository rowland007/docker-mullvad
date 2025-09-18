# Examples

Add `network_mode: service:mullvad` to another container's configuration to have it go through the VPN.

## Simple Example

```yaml
services:
    mullvad:
        image: ghcr.io/rowland007/docker-mullvad:latest
        container_name: mullvad
        hostname: mullvad
        environment:
           - - MULLVAD_ACCOUNT_TOKEN=${MULLVAD_ACCOUNT_TOKEN}
        restart: always
        privileged: true
        volumes:
            - mullvad_config:/config
    ip:
        image: alpine
        depends_on:
            - mullvad
        network_mode: service:mullvad
        command: sh -c 'sleep 1; wget -q -O - https://ifconfig.me/ip; echo'

volumes:
    mullvad_config:
```

## Expose Ports

If you have a service that normally exposes ports, but you want it to go through the VPN, you need to move those ports to the Mullvad service.

```yaml
services:
    mullvad:
        image: ghcr.io/rowland007/docker-mullvad:latest
        container_name: mullvad
        hostname: mullvad
        restart: always
        environment:
            - MULLVAD_ACCOUNT_TOKEN=${MULLVAD_ACCOUNT_TOKEN}
        privileged: true
        ports:
          - 8112:8112           # Deluge's WebGUI
          - 6881:6881           # Deluge's Inbound Torrents
          - 6881:6881/udp       # Deluge's Inbound Torrents
        volumes:
            - mullvad_config:/config
    deluge:
        image: lscr.io/linuxserver/deluge:latest
        container_name: deluge
        environment:
          - PUID=1000
          - PGID=1000
          - TZ=Etc/UTC
          - DELUGE_LOGLEVEL=error #optional
        volumes:
          - ./deluge/config:/config
          - ./deluge_downloads:/downloads
        restart: unless-stopped
        depends_on:
            - mullvad
        network_mode: service:mullvad

volumes:
    mullvad_config:
```