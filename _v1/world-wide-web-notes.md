---
layout: compsci-note
title: World Wide Web Notes
categories: [networks]
description: Some notes on the World Wide Web
---

## How the browser works

A summary of the different steps of what happens when you navigate to a website.

### 1. Hostname Resolution

When the URL is entered in the browser, e.g. `https://www.foo.com`, the browser observes the transport protocol (https) and the hostname.

The hostname must be resolved to an IP address on the network stack and a DNS request over UDP:53, usually the recursive strategy is employed, is made to the DNS servers.

The DNS servers will be queried in the following order:

1. Local server
2. Root DNS server
3. TLD DNS server
4. Authoritative servers

If a hostname entry is found in the DNS servers, it is subsequently returned to the browser. The local DNS server will cache this IP resolution for future requests. For this example, let us assume `foo.com` resolved to the IP address `1.2.3.4`.

### 2. Connecting over HTTPS

The HTTPS protocol was specified as part of the URL, today's browsers will default to HTTPS, and a TCP connection will be made over TLS to the IP address `1.2.3.4`.

It is important to remember that TLS is an **application** layer protocol however programmers often treat it as an transport layer protocol. Many steps occur as part of a TCP connection, much less TCP over TLS! To limit this exposition, many areas will be summarized.

* The  client (browser) would create a TCP socket, and additionally a TLS socket for the TLS layer, and the TCP three-way handshake would proceed.
* As part of the handshake, the server's identity is verified by the browser which validates its certificate with a certificate authority.
* The **symmetric session key** will be generated which will be used for encrypting and integrity checking for the rest of the session.

### 3. Data transfer

TCP is a byte-stream protocol and the data stream is broken into records - this enables the data and MAC to be combined and encrypted together. This enables both **confidentiality** and **data integrity**.
