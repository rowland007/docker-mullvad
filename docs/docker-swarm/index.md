# Using Docker Swarm

This process is more complex and may not meet everyone's needs. It is provided if you want to create your own image that will utilize Docker Secrets. A more secure way of passing sensitve information to the container.

## Key Security Benefits

### Advantages of Docker Secrets
- Encrypted storage of sensitive information
- Secrets are only mounted when explicitly requested
- Scoped access control
- Rotatable without modifying the application code

## Steps

1. Install Docker (see [:octicons-link-external-16:docs.docker.com](https://docs.docker.com/engine/install/))
2. Clone the repo
    ```bash
    git clone https://github.com/rowland007/docker-mullvad.git
    ```
3. `cd docker-mullvad`
4. Modify the `entrypoint.sh` file to add [line 6](#__codelineno-1-6)
    ```bash
    #!/bin/bash

    export MULLVAD_SETTINGS_DIR=/config

    # Read the Mullvad account token from the secret file
    MULLVAD_ACCOUNT_TOKEN=$(cat /run/secrets/mullvad_account_token)

    # Start the daemon
    mullvad-daemon &
    sleep 5

    # Configure and Login to Mullvad
    mullvad dns set default
    mullvad auto-connect set on
    mullvad account login $MULLVAD_ACCOUNT_TOKEN

    # Connect to VPN
    mullvad connect

    # Keep the container running
    tail -f /dev/null
    ```
5. Run the command below to create your own image
    ```bash
    docker build --no-cache --pull -t docker-mullvad:personal
    ```

## Run Docker Swarm

1. Run `docker swarm init`
2. Create a Docker Secret replacing `your_mullvad_account_token` with your account number
    ```bash
    echo "your_mullvad_account_token" | docker secret create mullvad_account_token -
    ```
3. Modify the `docker-compose.yml` file to include "secrets"
    ```yaml
    services:
      mullvad:
        image: docker-mullvad:personal
        container_name: mullvad
        hostname: mullvad
        secrets:
           - mullvad_account_token       
        restart: always
        privileged: true
    volumes:
       - mullvad_config:/config
    secrets:
      mullvad_account_token:
        external: true
    ```
4. Run
    ```bash
    docker stack deploy -c docker-compose.yml mullvad
    ```
