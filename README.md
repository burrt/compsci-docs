# Computer Science Notes

A collection of Computer Science and Engineering notes I've jotted down across the years.
I thought I'd use Jekyll to organize and view these notes as they're starting to grow quickly.

## In-browser viewing

These docs are hosted on [Github Pages](https://burrt.github.io/compsci-docs/).

### Building

Setup and install [Jekyll](#https://jekyllrb.com/docs/) and then run depending on your OS:

```bash
# Windows - Powershell
docker run --rm --label=jekyll --volume=${pwd}:/srv/jekyll  -it -p 4000:4000 jekyll/jekyll jekyll serve --force_polling --config _config.yml,_config_development.yml

# Linux
bundle update
bundle exec jekyll serve --config _config.yml,_config_development.yml
```
