# Build your own Image using Docker

Docker Build[^1] is one of Docker Engine's most used features. Whenever you are creating an image you are using Docker Build. Build is a key part of your software development life cycle allowing you to package and bundle your code and ship it anywhere.

[^1]: [:octicons-link-external-16:Docker Build Overview](https://docs.docker.com/build/concepts/overview/)

## Steps to build

1. Install Docker (see [:octicons-link-external-16:docs.docker.com](https://docs.docker.com/engine/install/))
2. Clone the repo
    ```bash
    git clone https://github.com/rowland007/docker-mullvad.git
    ```
3. `cd docker-mullvad`
4. Run
    ```bash
    docker build --no-cache --pull -t docker-mullvad:personal
    ```

## Test your Image

Run

```bash
docker run -d --privileged -v ./config:/config -e MULLVAD_ACCOUNT_TOKEN=<changeme> --name mullvad docker-mullvad:personal
```