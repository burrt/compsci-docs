docker run `
    --rm `
    --label=jekyll/jekyll:3.8 `
    --volume=${pwd}:/srv/jekyll `
    -it -p 4000:4000 jekyll/jekyll `
    jekyll serve --force_polling
