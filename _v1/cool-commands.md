---
layout: default
title: Angular Notes
categories: [web-dev]
description: Some basic notes on Angular
order: 20
sitemap: false
---

## Finding stuff

There's too many cool things with `grep` so I'll have to limit this, also heard `Ag` is interesting as well.

Flags to take note of:

* `-r`: recursive
* `-n`: line numbers
* `-i`: case insensitive
* `-l`: only show file names with matches
* `-v`: invert search
* `-w`: whole word match

```bash
egrep -irn "^hello.*" --exclude-dir=".*"    # exclude .directories
egrep -irn "hello$" --include=\*.{py,}      # that trailing comma is important!
egrep -i '^(COMP[29]041).*(\|F$)'           # standard cool regex

git grep -iE '(events).*'                   # ignore case, extended regex
git grep -iIE '(events)[a-z]*' -- '*.cs'    # only include .cs files

find . -name CASE_SENSITIVE_FILENAME        # other tricks that I don't know
find . -name "*.jg" | grep -i "wallpaper"
```

## Misc commands

```bash
wc -l                               # word count, I always forget this one
cut -d '|' -f2 file | sort | uniq   # -d delimiter, -f2 'group' and stuff
```

## Memory related

```bash
xxd -i file                 # will print output of file as a hex array in C!
hexdump -C file | less      # show ascii value on the right
objdump -rD hello.elf       # dump dissassembled ELF with relative
readelf -a hello.elf        # show section header/tables etc.
```