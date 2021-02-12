---
layout: compsci-note
title: Docker Notes
categories: [docker, tools]
description: Some notes on Docker
order: 20
sitemap: false
---

## Links

* [Docker Docs](#https://docs.docker.com/)

## Basics

```bash
# show running containers
$ docker ps

$ docker rm <container>
$ docker rmi <image>

# list images
$ docker images

# get IP address of container
$ docker inspect -f "{{ .NetworkSettings.IPAddress }}" <containerNameOrId>

# run commands
$ docker exec -it <mycontainer> bash
```
