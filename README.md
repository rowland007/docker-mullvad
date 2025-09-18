# Docker-Mullvad

![Mullvad Version](https://img.shields.io/badge/Version-2025.9-teal?style=plastic&logo=mullvad)  
![Docker Image Status](https://github.com/rowland007/docker-mullvad/actions/workflows/docker-build.yml/badge.svg)  
![MkDocs Deployment Status](https://github.com/rowland007/docker-mullvad/actions/workflows/mkdocs.yml/badge.svg)  
[![GitKraken Shield](https://img.shields.io/badge/Made%20With-GitKraken%20Git%20Tools-teal?style=plastic&logo=gitkraken)](https://www.gitkraken.com/invite/54HeFuDe)


# Overview

Your IP address is used to identify you, track you, and map your online life. Step 1 in taking back your personal privacy online is masking it with a trustworthy VPN. This Docker image uses the latest version of the [Mullvad VPN for Linux](https://mullvad.net/en/download/vpn/linux) so you can have other Docker containers use its VPN connection.

# Configuration

## Setup Mullvad VPN the first time only

1. Open the `.env` file or create your own.
2. Remove the `changeme` and add your account number (or)
3. Add `MULLVAD_ACCOUNT_TOKEN=` to your own file and add your account number after the `=`
4. Start the container with `docker compose up mullvad`
5. Restart the container when it becomes unreponsive, you'll see an error about "*Failed to generate tunnel parameters*"
    (For some reason, it fails to connect the first time.)

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

Add `network_mode: service:mullvad` to a service's configuration. For an example, see [vpn-example](https://github.com/rowland007/docker-mullvad/blob/master/docker-compose.example)

---

This Dockerfile is based on [oblique/mullvad](https://github.com/oblique/dockerfiles/tree/master/mullvad).
