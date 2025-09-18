# Using Docker Compose

## Steps

1. Install Docker (see [:octicons-link-external-16:docs.docker.com](https://docs.docker.com/engine/install/))
2. Download the `docker-compose.yml` and `.env` file from the repo
3. Replace the `changeme` inside the `.env` file with your account number
4. Run
    ```bash
    docker compose pull
    ```
5. Run
    ```bash
    docker compose up mullvad
    ```
6. Wait until you see your account login and the container become unresponsive.
7. In a different terminal window, run
    ```bash
    docker stop mullvad
    ```
8. Now restart the container
    ```bash
    docker compose up mullvad -d
    ```
9. Get in the container
    ```bash
    docker exec -it mullvad /bin/bash
    ```
10. Check the status of Mullvad (within the container)
    ```bash
    mullvad status
    ```
11. If everything looks good, you can type `exit` to get out of the container.