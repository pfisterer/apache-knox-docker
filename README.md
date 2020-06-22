# Run Apache Knox in Docker

Docker container for [Apache Knox](https://knox.apache.org/), which is an Application Gateway for interacting with the REST APIs and UIs of Apache Hadoop deployments. The image is available on Dockerhub: <https://cloud.docker.com/u/farberg/repository/docker/farberg/apache-knox-docker>.

A helm chart for deployment on k8s is available here: [pfisterer/apache-knox-helm](https://github.com/pfisterer/apache-knox-helm).

## Available versions

| Apache Knox Version | Docker Tag                        |
| ------------------- | --------------------------------- |
| latest              | farberg/apache-knox-docker:latest |
| 1.4.0               | farberg/apache-knox-docker:1.4.0  |
| 1.3.0               | farberg/apache-knox-docker:1.3.0  |

Example (required for the commands below to work)

```bash
export KNOX_VERSION=1.4.0
```

## Run Apache Knox in Docker

Using the default configuration files:

```bash
docker run --rm -ti farberg/apache-knox-docker:$KNOX_VERSION
```
Using your own configuration files:

```bash
docker run --rm -ti -v /path/to/your/config:/opt/knox/conf farberg/apache-knox-docker:$KNOX_VERSION

# Example on MacOS/Linux: 
# docker run --rm -ti -v $PWD/my-conf/:/opt/knox/conf/ farberg/apache-knox-docker:$KNOX_VERSION
# docker run --rm -ti -v $PWD/my-conf-1.4.0/:/opt/knox/conf/ farberg/apache-knox-docker:$KNOX_VERSION
```

## Build this Docker container

```bash
docker build -t farberg/apache-knox-docker:$KNOX_VERSION .

docker tag farberg/apache-knox-docker:$KNOX_VERSION farberg/apache-knox-docker:latest
```

## Push this Docker container to Dockerhub

```bash
docker login
echo "farberg/apache-knox-docker:$KNOX_VERSION" 'farberg/apache-knox-docker:latest' | xargs -n 1 docker push
```

