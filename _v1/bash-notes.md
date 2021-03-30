---
layout: compsci-note
title: Bash Notes
categories: [bash, scripting]
description: Some basic stuff on Bash
sitemap: false
---

## Bash

## Portability

The raging debate with bash vs shell scripts...

```bash
#!/bin/sh
value=`cat config.txt`
echo "$value"
```

### Bash method

Don't use `cat` in `bash` for some reason?

```bash
  #!/usr/bin/env bash
  value=$(<config.txt)
  echo "$value"
```

## Beginner stuff

```bash
# rename files
for file in *.JPG *.jpeg
    do mv -- "$file" "${file%.*}.jpg"
done

# remove all .ext files
for file in *.junk
    do rm "$file"
done
```

### Incrementing variables

`var=$((var+=1))`

### Basic

```bash
# if statement
if COMMANDS; then
    OTHER COMMANDS
elif COMMANDS; then
    OTHER COMMANDS
else
    OTHER COMMANDS
fi

# loops
for (( i=10; i > 0; i-- ))
    do echo "$i empty cans of beer."
done

for i in {10..1}
    do echo "$i empty cans of beer."
done
```

### Arguments processing

Supports space separated or `=` i.e. `--option=foo -o foo`

```bash
# check if args are supplied
if [ $# -eq 0 ]
then
    echo "Using default settings"
else
    for i in "$@"
    do
    case $i in
        -a=*|--aw=*)
        AWURL="${i#*=}"
        ;;
        -a*|--aw*)
        AWURL="$2"
        shift
        shift
        ;;
        -k=*|--key=*)
        APIKEY="${i#*=}"
        ;;
        -k*|--key*)
        APIKEY="$2"
        shift
        shift
        ;;
        -h*|--help*)
        printf "${HELP}"
        exit 0
        ;;
        --default)
        DEFAULT=YES
        ;;
        *)
        # unknown option
        ;;
    esac
    done
fi
```
