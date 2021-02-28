---
layout: compsci-note
title: Random Useful Notes
categories: [other]
description: Some notes I find pretty handy
sitemap: false
favorite: true
---

## Exiting VIM

`:wq` or `:x`

The only commands you need to know - then switch to Emacs.

## Random Linux stuff

```bash
sha256sum file | diff - shafile             # generate sha-256
export PATH=$PATH:~/opt/bin:~/opt/node/bin  # export PATH
history -c                                  # reset history
reset

# scp
scp /file/to/send username@remote:/where/to/put
scp username@remote:/file/to/send /where/to/put
```

### time

```bash
time a.out
# real 0m0.003s  # user + system: often 'stopwatch'
                 # not 'accurate' - fork(), program might
                 # not be running at all
# user 0m0.000s  # in userland
# sys  0m0.001s  # kernel time e.g. syscalls, interrupts
```

### Adding user to another group

`usermod -aG additional_groups username`

* Be sure you don't omit the `-a` flag, otherwise it will also remove the user from groups not in `additional_groups`
* List of groups in `/etc/groups`

### Adding your scripts to PATH

* Create your `~/bin` directory
* In your `.bashrc`, add it to your `PATH=$PATH:~/bin` (this is appending it to PATH)
* Add a shebang `#!/bin/bash` to your script
  * Better to use `#!/usr/bin/env bash`
* Give it exec permissions: `chmod +x script`

### Redirection

`./somescript >/dev/null 2>&1`

To break it up:

* `2` is the handle for standard error or `STDERR`
* `1` is the handle for standard output or `STDOUT`
* `2>&1` is asking to direct all the `STDERR` as `STDOUT`, (i.e. to treat all the error messages generated from the script as its standard output).
  * Now we already have `>/dev/null` at the end of the script which means **all** `STDOUT` will be written to `/dev/null`.
  * Since `STDERR` is now going to `STDOUT` (because of `2>&1`) both `STDERR` **and** `STDOUT` go to `/dev/null`.

### File handlers

| Integer value | Name            | `<unistd.h>` symbolic constant | `<stdio.h>` file stream |
|---------------|-----------------|--------------------------------|-------------------------|
| 0             | Standard input  | `STDIN_FILENO`                 | stdin                   |
| 1             | Standard output | `STDOUT_FILENO`                | stdout                  |
| 2             | Standard error  | `STDERR_FILENO`                | stderr                  |
