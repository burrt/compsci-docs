---
layout: compsci-note
title: World Wide Web Notes
categories: [networks]
description: Some notes on the World Wide Web
sitemap: false
---

## How the browser works

1. URL is entered in the browser
2. DNS server request is made (UDP:53) for `foo.com` by the browser
3. DNS server responds with the IP address of the server `1.1.1.1`
4. The local machine caches the DNS response data and sends an access request for `foo.com` to the server with an IP address `1.1.1.1`
5. The server `1.1.1.1` establishes a TCP connection with the local machine for data exchange

### TCP and HTTP

Once the TCP connection is setup up (handshake etc.), data transfer is ready. To transfer data, the connection must meet the requirements of the HTTP protocol 1.0/1.1, including connection, messaging, request and response rules.

### HTML data

Once the HTML page of the website is sent from the server and is received at the browser, it converts it to a structured object (DOM tree) in memory. It then renders elements in the DOM tree as visual items.

Whilst the DOM tree is rendered from top to bottom, the browser will initiate any HTTP request on external resources/scripts (links, image tags etc.).

### Cookies

Cookies are stored locally on a user's computer and usually contains information of the user's browsing activity.

The HTTP protocol defines a list of operations of cookies. Cookies are ideally isolated by the domain name (excluding child-level domains) and are attached to the HTTP request before being sent to the backend server.
