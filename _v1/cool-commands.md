---
layout: compsci-note
title: Cool Commands
categories: [random]
description: Some cool commands on Linux
sitemap: false
---

## Contents

* [Finding stuff](#finding-stuff)
* [File system](#file-system)
* [Misc commands](#misc-commands)

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

### Tar files

```bash
tar -xvf file_name.tar                                  # Untar files in Current Directory
tar -xvf file_name.tar -C /home/public_html/videos/     # Untar files in specified Directory

tar -xvf tarfile.tar.gz                                 # Untar .gz
tar -xvf videos-14-09-12.tar.bz2                        # Untar .bz2
tar xf archive.tar.xz
tar xf archive.tar.gz
tar xf archive.tar

tar -cvf output.tar /dirname1 /dirname2 filename1       # create tar files
tar -tvf file.tar                                       # list contents of .tar
```

### Zip files

```bash
zip data *                      # create data.zip of current directory
zip -r data *                   # create data.zip ^ + all subfolders + hidden items

unzip pics.zip
unzip -tq pics.zip              # print summary message indicating if archive is OK
unzip pics.zip  cv.doc          # To extract the file called cv.doc from pics.zip
unzip pics.zip  -d /tmp         # unzip to specified directory
unzip -l data.zip               # list contents
```

## Processes

```bash
htop                              # running processes and utilization + PIDs
top                               # less user-friendly but default on most
ps axjf                           # tree view of COMPLETE running processes
pgrep firefox                     # get PID or can use: pidof firefox

kill PID_of_proc                  # to safely exit or use
kill -9 PID_of                    # to escalate to KILL, 15 is safe
pkill proc_name                   # instead of PID, give the name
killall -9 service

```

## File system

```bash
df -h                             # shows all directories and mounted media
df -hT /home                      # just /home file size
du -shc   /dir                    # if you just want a folder or "." curr dir
blockdev --getsize64 <device>     # get size of device

rsync --info=progress2 -avr --ignore-existing /src /dest

sudo udisks --unmount /dev/sdb1   # check df -h for usb drive
sudo udisks --detach /dev/sdb
```

Misc commands

```bash
history | less                      # history of commands. history n
wc -l                               # word count, I always forget this one
cut -d '|' -f2 file | sort | uniq   # -d delimiter, -f2 'group' and stuff
```

## Memory related

```bash
xxd -i file                 # will print output of file as a hex array in C!
hexdump -C file | less      # show ascii value on the right
objdump -rD hello.elf       # dump disassembled ELF with relative
readelf -a hello.elf        # show section header/tables etc.
```
