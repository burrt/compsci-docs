# Computer Science Notes

A collection of Computer Science and Engineering notes I've jotted down across the years.
I thought I'd use Jekyll to organize and view these notes as they were starting to grow pretty quick.

## In-browser viewing

These docs are hosted on [Github Pages](https://burrt.github.io/compsci-docs/).

## Getting Started

```sh
# clone the repository
$ git clone https://github.com/burrt/compsci-docs.git
```

### Docker

```bash
$ docker-compose up
```

### Linux

Instead of Docker (recommended), you can setup and install [Jekyll](https://jekyllrb.com/docs/) and then run:

```bash
$ bundle install
$ bundle exec jekyll serve --incremental
```

## Upgrading and maintenance

See the `docker-compose.yml` file for the Jekyll image versions and the GitHub Pages support.
To upgrade the Gem versions, see [Jekyll Docker - updating](https://github.com/envygeeks/jekyll-docker/tree/master#updating).

**With Docker**:

```bash
export JEKYLL_VERSION=3.8
docker run --rm \
  --volume="$PWD:/srv/jekyll:Z" \
  -it jekyll/jekyll:$JEKYLL_VERSION \
  bundle update github-pages
```

**With Linux**:

#
```bash
$ bundle update github-pages
```

**See also**: the jekyll plugin releases in `Gemfile` to upgrade.
