---
layout: compsci-note
title: Python Tools Notes
categories: [tools]
description: Some notes on useful tools for Python
order: 20
sitemap: false
---

## Contents

* [Basics](#basics)

## Basics

Similar to how virtual environments work in Python, but also for Pip.

Actually super handy since it can create a new virtualenv using a specific version of Python that you've installed.

```bash
# if a Pipfile exists, install all package dependencies
pipenv install

# install specific requests version 1.2/x
pipenv install requests~=1.2

# use Python 3/2.7 if exists in PATH
pipenv --python3
pipenv --python 2.7

pipenv uninstall requests

# creates a Pipfile.lock that declares all dependencies and sub-dependencies versions, hashes etc.
pipenv lock
```
