# Using Docker create a container

!!! warning Warning
    It is recommended to use [Docker Compose](../docker-compose/index.md) over the standard `docker run` command.


## Steps

1. Install Docker (see [:octicons-link-external-16:docs.docker.com](https://docs.docker.com/engine/install/))
2. Pull the image
    ```bash
    docker pull ghcr.io/rowland007/docker-mullvad:latest
    ```
3. Have your Mullvad account number handy
4. Change the `<changeme>` in the below command to your account number
5. Run
    ```bash
    docker run -d --privileged -v ./config:/config -e MULLVAD_ACCOUNT_TOKEN=<changeme> --name mullvad ghcr.io/rowland007/docker-mullvad:latest
    ```