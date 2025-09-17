# Docker-Mullvad

![Mullvad Version](https://img.shields.io/badge/Version-2025.9-teal?style=plastic&logo=mullvad)  
![Docker Image Status](https://github.com/rowland007/docker-mullvad/actions/workflows/docker-build.yml/badge.svg)  
![MkDocs Deployment Status](https://github.com/rowland007/docker-mullvad/actions/workflows/mkdocs.yml/badge.svg)  
[![GitKraken Shield](https://img.shields.io/badge/Made%20With-GitKraken%20Git%20Tools-teal?style=plastic&logo=gitkraken)](https://www.gitkraken.com/invite/54HeFuDe)


# Overview

Your IP address is used to identify you, track you, and map your online life. Step 1 in taking back your personal privacy online is masking it with a trustworthy VPN. This Docker image uses the latest version of the [Mullvad VPN for Linux](https://mullvad.net/en/download/vpn/linux) so you can have other Docker containers use its VPN connection.

# Configuration

## Setup Mullvad VPN the first time only

```bash
docker compose up -d mullvad
docker compose exec mullvad bash
```

### Inside of the container

```bash
mullvad relay set tunnel-protocol wireguard
mullvad always-require-vpn set on
mullvad auto-connect set on
mullvad account login [ACCOUNT_NUMBER]
mullvad connect
exit
```

### Out of the container

```bash
docker compose down
```

## After first time setup

### Start it

```bash
docker compose up -d
```

## Use VPN from another container

### Docker Run

For `docker run`, use `--net=container:mullvad_vpn`, for example:

```bash
docker run -it --rm --net=container:mullvad alpine
```

## Docker Compose

Add `network_mode: service:mullvad` to a service's configuration. For an example, see [vpn-example](https://github.com/oblique/dockerfiles/blob/master/composefiles/vpn-example/docker-compose.yml)

---

This Dockerfile is based on [oblique/mullvad](https://github.com/oblique/dockerfiles/tree/master/mullvad).
