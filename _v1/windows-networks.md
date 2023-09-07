---
layout: compsci-note
title: Windows Networking Notes
categories: [networks, windows]
description: Some notes on Windows Networking
---

## Windows Name Resolution

### DNS

### NetBIOS

Is 16 ASCII characters, the 16th is reserved for the type of service/name. The host name (short host name) is specified when Windows networking is installed/configured. The NetBIOS name does not need to be the same as the computer's host name (internet.

To connect to a computer running TCP/IP via its NetBIOS name, it needs to be resolved to a network address - usually IP address. This can be done with broadcasts or a WINS Server (NetBIOS Name Server) and is used as a last resort when resolving hostnames.

### Other

* Link-Local Multi-cast Name Resolution (LLMNR)
* Peer Name Resolution
* Server Network Information Discovery
