# Computer Science Notes

A collection of Computer Science and Engineering notes I've jotted down across the years.
I thought I'd use Jekyll to organize and view these notes as they were starting to grow quickly.

## In-browser viewing

These docs are hosted on [Github Pages](https://burrt.github.io/compsci-docs/).

### Building

Clone the repository:

```sh
$> git clone https://github.com/burrt/compsci-docs.git
```

### Linux

Setup and install [Jekyll](#https://jekyllrb.com/docs/) and then run:

```bash
$> bundle install
$> bundle exec jekyll serve --config _config.yml,_config_development.yml
```

### Windows

#### Docker

```powershell
# Powershell
PS> docker run `
    --rm `
    --label=jekyll `
    --volume=${pwd}:/srv/jekyll `
    -it -p 4000:4000 jekyll/jekyll `
    jekyll serve `
        --force_polling `
        --config _config.yml,_config_development.yml
```

Or alternatively, run the Powershell script `.\RunDocker.ps1`.
