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
$ bundle exec jekyll serve --config _config.yml,_config_development.yml
```

## Upgrading Gems

To test upgrading of the Gems for either new features and/or security vulnerabilities:

```bash
$ bundle update github-pages
```
