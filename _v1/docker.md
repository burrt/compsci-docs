---
layout: compsci-note
title: Docker Notes
categories: [docker, tools]
description: Some notes on Docker
order: 20
sitemap: false
---

## Links

* [Docker Machine](#https://docs.docker.com/machine/get-started/#use-machine-to-run-docker-containers)

## Basics

```bash
# show running containers
docker ps

# clean up container
docker rm

# list images
docker images

# get IP address of container
docker inspect -f "{{ .NetworkSettings.IPAddress }}" <containerNameOrId>

# run commands
docker exec -it <mycontainer> bash
```

## Postgres container

Refer to [the docs](#https://docs.docker.com/samples/library/postgres/#start-a-postgres-instance) for the complete details. [Here is also another link that might be useful](#https://medium.com/@lvthillo/connect-from-local-machine-to-postgresql-docker-container-f785f00461a7).

```bash
docker run --name some-postgres -e POSTGRES_PASSWORD=mysecretpassword -d postgres

# linking it to your app
docker run --name some-app --link some-postgres:postgres -d application-that-uses-postgres
```

## Jekyll

### Windows

```bash
docker run --rm --label=jekyll --volume=${pwd}:/srv/jekyll -it -p 4000:4000 jekyll/jekyll jekyll serve --force_polling
```
