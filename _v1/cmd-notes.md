---
layout: default
title: CMD Notes
categories: [cmd, windows]
description: Some notes on cmd commands and batch
order: 20
sitemap: false
---

# Basics

```cmd
cls  # clear screen
date  # or time
find
pause  # pauses the execution of a batch file
runas  # start a program as another user
shutdown
sort
tasklist
taskkill
w32tm  # setting time sync/zone/server
```

## File

```cmd
attrib  # file attributes
comp  # compare file contents
copy/xcopy  # copy files
del  #
rmdir /q /s # remove dir recursively and silent
tree # show directories graphically
```

## Network

```cmd
ipconfig  # /all, /release /renew
nslookup  # query DNS
telnet
tracert
```

## Batchfiles

Overview of some basic functionality you can use:

* `"%~dp0`: path of the batchfile script (regardless of where the batchfile is ran)
  * This also handles paths with spaces
* `%cd%`: refers to the current working directory (variable)
* `%~dpnx0`: refers to the full path to the batch directory and file name (static)
* `ECHO OFF` don't print commands to console
* `%~1`: argument
* `^`: use this for 'line-wrapping' for long commands
* `IF /I "%~1" == "/quiet" set verbosity=quiet`: case insensitive match, there is no else-if

```cmd
IF %F%==1 IF %C%==1 (
    ::copying the file c to d
    copy "%sourceFile%" "%destinationFile%"
    )

IF NOT EXIST "temp.txt" ECHO not found

:: Check for errors
ls
if %ERRORLEVEL% neq 0 exit /b %ERRORLEVEL%
```