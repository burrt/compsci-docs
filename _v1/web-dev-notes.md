---
layout: compsci-note
title: Web Development Notes
categories: [web-dev]
description: Some basic notes on HTML/CSS
order: 20
sitemap: false
---

## Contents

* [HTTP Codes](#http-codes)
* [HTML Basics](#html)
* [CSS Basics](#css)

## HTTP Codes

* [Complete List](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes)
* [2XX Success](#2xx-success)
* [3XX Redirection](#3xx-redirection)
* [4XX Client errors](#4xx-client-errors)
* [5XX Server errors](#5xx-server-errors)

### 2XX Success

| Code                                | Description                                                                                                                                                                                                                                                   |
|-------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `200 OK`                            | In a GET request - recv stuff. In a POST - recv result.                                                                                                                                                                                                       |
| `201 Created`                       | The request has been fulfilled, resulting in the creation of a new resource.                                                                                                                                                                                  |
| `202 Accepted`                      | The request has been accepted for processing, but the processing has not been completed. The request might or might not be eventually acted upon, and may be disallowed when processing occurs.                                                               |
| `203 Non-Authoritative Information` | The server is a transforming proxy (e.g. a Web accelerator) that received a `200 OK` from its origin, but is returning a modified version of the origin's response.                                                                                           |
| `204 No Content`                    | The server successfully processed the request and is not returning any content.                                                                                                                                                                               |
| `205 Reset Content`                 | The server successfully processed the request, but is not returning any content. Unlike a 204 response, this response requires that the requester reset the document view.                                                                                    |
| `206 Partial Content`               | The server is delivering only part of the resource (byte serving) due to a range header sent by the client. <br>The range header is used by HTTP clients to enable resuming of interrupted downloads, or split a download into multiple simultaneous streams. |

### 3XX Redirection

| Code                     | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
|--------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `300 Multiple Choices`   | Indicates multiple options for the resource from which the client may choose (via agent-driven content negotiation). For example, this code could be used to present multiple video format options, to list files with different filename extensions, or to suggest word-sense disambiguation.                                                                                                                                                                                                          |
| `301 Moved Permanently`  | This and all future requests should be directed to the given URI.                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| `302 Found`              | This is an example of industry practice contradicting the standard. The HTTP/1.0 specification required the client to perform a temporary redirect (the original describing phrase was "Moved Temporarily"), but popular browsers implemented `302` with the functionality of a `303 See Other`. <br>Therefore, HTTP/1.1 added status codes `303` and `307` to distinguish between the two behaviours. However, some Web applications and frameworks use the `302` status code as if it were the `303`. |
| `303 See Other`          | The response to the request can be found under another URI using a `GET` method. When received in response to a `POST` (or `PUT/DELETE`), the client should presume that the server has received the data and should issue a redirect with a separate `GET` message.                                                                                                                                                                                                                                    |
| `304 Not Modified`       | Indicates that the resource has not been modified since the version specified by the request headers If-Modified-Since or If-None-Match. <br>In such case, there is no need to retransmit the resource since the client still has a previously-downloaded copy.                                                                                                                                                                                                                                         |
| `305 Use Proxy`          | The requested resource is available only through a proxy, the address for which is provided in the response. <br>Many HTTP clients (such as Mozilla and IE) do not correctly handle responses with this status code, primarily for security reasons.                                                                                                                                                                                                                                                    |
| `307 Temporary Redirect` | In this case, the request should be repeated with another URI; however, future requests should still use the original URI. <br>In contrast to how 302 was historically implemented, the request method is not allowed to be changed when reissuing the original request. e.g. a `POST` request should be repeated using another `POST` request.                                                                                                                                                         |
| `308 Permanent Redirect` | The request and all future requests should be repeated using another URI. `307` and `308` parallel the behaviours of `302` and `301`, but do **not** allow the HTTP method to change. <br>So, for example, submitting a form to a permanently redirected resource may continue smoothly.                                                                                                                                                                                                                |

### 4XX Client errors

| Code                    | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
|-------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `400 Bad Request`       | The server cannot or will not process the request due to an apparent client error (e.g., malformed request syntax, size too large, invalid request message framing, or deceptive request routing).                                                                                                                                                                                                                                                                                                                   |
| `401 Unauthorized`      | Similar to `403 Forbidden`, but specifically for use when authentication is required and has failed or has not yet been provided. The response must include a WWW-Authenticate header field containing a challenge applicable to the requested resource. `401 semantically` means "unauthenticated", i.e. the user does not have the necessary credentials. <br>Note: Some sites issue `HTTP 401` when an IP address is banned from the website and that specific address is refused permission to access a website. |
| `402 Payment Required`  | Reserved for future use. The original intention was that this code might be used as part of some form of digital cash or micropayment scheme, but that has not yet happened, and this code is not usually used. <br>Google Developers API uses this status if a particular developer has exceeded the daily limit on requests.                                                                                                                                                                                       |
| `403 Forbidden`         | The request was valid, but the server is refusing action. The user might not have the necessary permissions for a resource, or may need an account of some sort.                                                                                                                                                                                                                                                                                                                                                     |
| `404 Not Found`         | The requested resource could not be found but may be available in the future. Subsequent requests by the client are permissible                                                                                                                                                                                                                                                                                                                                                                                      |
| 408 Request Timeout     | The server timed out waiting for the request."The client did not produce a request within the time that the server was prepared to wait. The client MAY repeat the request without modifications at any later time."                                                                                                                                                                                                                                                                                                 |
| `413 Payload Too Large` | The request is larger than the server is willing or able to process. Previously called "Request Entity Too Large".                                                                                                                                                                                                                                                                                                                                                                                                   |
| `414 URI Too Long`      | The URI provided was too long for the server to process. Often the result of too much data being encoded as a query-string of a GET request, in which case it should be converted to a POST request.Called "Request-URI Too Long" previously.                                                                                                                                                                                                                                                                        |

### 5XX Server errors

| Code                                  | Description                                                                                                                                                                                                                                                               |
|---------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `500 Internal Server Error`           | A generic error message, given when an unexpected condition was encountered and no more specific message is suitable.                                                                                                                                                     |
| `501 Not Implemented`                 | The server either does not recognize the request method, or it lacks the ability to fulfil the request. Usually this implies future availability (e.g., a new feature of a web-service API).                                                                              |
| `502 Bad Gateway`                     | The server was acting as a gateway or proxy and received an invalid response from the upstream server.                                                                                                                                                                    |
| `503 Service Unavailable`             | The server is currently unavailable (overloadedd/down for maintenance). Generally, this is a temporary state.                                                                                                                                                             |
| `504 Gateway Timeout`                 | The server was acting as a gateway or proxy and did not receive a timely response from the upstream server.                                                                                                                                                               |
| `505 HTTP Version Not Supported`      | The server does not support the HTTP protocol version used in the request.                                                                                                                                                                                                |
| `506 Variant Also Negotiates`         | Transparent content negotiation for the request results in a circular reference.                                                                                                                                                                                          |
| `507 Insufficient Storage`            | The server is unable to store the representation needed to complete the request.                                                                                                                                                                                          |
| `508 Loop Detected`                   | The server detected an infinite loop while processing the request.                                                                                                                                                                                                        |
| `510 Not Extended`                    | Further extensions to the request are required for the server to fulfil it.                                                                                                                                                                                               |
| `511 Network Authentication Required` | The client needs to authenticate to gain network access. Intended for use by intercepting proxies used to control access to the network (e.g., "captive portals" used to require agreement to Terms of Service before granting full Internet access via a Wi-Fi hotspot). |

## HTML

Quick examples:

```html
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <title>My test page</title>
  </head>
  <body>
    <p>This is my page</p>
  </body>
</html>
```

### Basics

```html
<!--
    Acts as a container for everything that you DON'T want to show on the page - metadata.
    e.g. description, CSS, char set declarations, title
-->
<head></head>

<!--
    Sets the char set to UTF-8
-->
<meta charset="utf-8">

<!--
    Useful for setting author, descriptions etc.
    for search engines (key words), web scrappers
-->
<meta name="author" content="Geoff">

<!--
    Sets the title of the page.
-->
<title></title>

<link rel="stylesheet" href="my-css-file.css">

<!--
    Usually, placing this at the end before </body> is better since
    the JS may attempt to access an element that doesn't exist yet
    in the HTML content.
-->
<script src="my-js-file.js"></script>

<h1><h2>...<h6>
<p>paragraphs</p>
<br></br>

<ul><!-- Unordered list -->
    <li>List item</li>
</ul>

<ol><!-- Ordered lists -->
    <li>1. First</li>
    <li>2. Second</li>
</ol>

<!-- Strong importance and emphasis - contextual.

This affects e-readers where the word is read louder/tone.
Emphasis or strong importance elements are automatically
converted to italics and bold but shouldn't be used for
these purposes since they're contextual.
-->
<em>Emphasis - italics</em>
<strong>Strong importance</strong>

<i>Italics - foreign words, technical terms, thought..</i>
<b>Bold - start of a list item, product name, key words</b>
<u>Underlined - proper name, misspelling..</u>

<!-- Hyperlinks

You can also hyperlink images or anything else.
The title attribute for hover over.
The target attribute can also be used for opening
in new tab/window behavior.
The download attribute to supply a default file name on save.
The mailto: attribute uses the default email application
to mail to the specified email address.

You can also use the id attribute to use as anchors.
-->
<a href="url.com"
   title="Facebook sucks">
   Inline text here.
</a>
<a href="url.com"
    <img> src"url.com"</img>
</a>
<a href="...download.url.com"
   download="firefox-39-installer.exe">
  Download Firefox 39 for Windows
</a>
<a href="mailto:nowhere@mozilla.org">
    Send email to nowhere
</a>
<a href="mailto:nowhere@mozilla.org?
    cc=name2@rapidtables.com&
    bcc=name3@rapidtables.com&
    subject=The%20subject%20of%20the%20email&
    body=The%20body%20of%20the%20email">
    Send mail with cc, bcc, subject and body
</a>

<!-- Anchoring -->
<h1 id="Heading_link">Contents</h1>
<a href="index.html#Heading_link">link to heading</a>


<!-- Description lists

heading
    Paragraph description...
-->
<dl>
  <dt>soliloquy</dt>
  <dd>In drama, where a character speaks to themselves, representing their
      inner thoughts or feelings and in the process relaying them to
      the audience (but not to other characters.)</dd>
  <dt>monologue</dt>
  <dd>In drama, where a character speaks their thoughts out loud to share
      them with the audience and any other characters present.</dd>
  <dt>aside</dt>
  <dd>In drama, where a character shares a comment only with the audience
      for humorous or dramatic effect. This is usually a feeling, thought,
      or piece of additional background information.</dd>
</dl>


<!-- comment -->
<link href="/style.css" type="css">
<div class="somegroupname one">
    <h1></h1>
    <p></p>
    ...
</div>
<div class="somegroupname two">
</div>

```

#### Quotations

```html
<blockquote>Stuff inside here will automatically render as an indented paragraph.</blockquote>

<!-- You would probably like to cite sources in the hyperlinks -->
<p>
    <blockquote>
        <a href="url.com"><cite>The docs say that: (italics)</cite></a>
        Stuff inside here will automatically render as an indented paragraph.
    </blockquote>
</p>

<!-- If you want an inline quote (without rendering a paragraph) -->
<p>
    <q>
        Stuff inside here will automatically render as an inline quote.
        It will also be wrapped with double quotes!
    </q>
    -- <a href="url.com"><cite>The docs say that: (italics)</cite></a>
</p>
```

## CSS

```css
element {
    color: Blue;
    }

* {
    applying to all elements
    color: rgba(12, 13, 14, 1);      // get color values from a color picker, 4th arg opacity
    color: #AABBCC;                  // or represent it in hex
    color: hsl(182, 20%, 50%, 0.5);  // hsl: hue, saturation, lightness, opacity : careful of browser support
    text-align: center;
    }

div.classname {
    font-family: Roboto, Helvetica, sans-serif;
    }

.somegroupname {
    font-weight: 100;
    letter-spacing: 2px;
    margin: 20px;
    text-transform: uppercase;
    }

.one {
    min-height: 100px;
    max-width: 200px;
    overflow: scroll;  // or hidden, useful when you overflow your boxes
    }

/* Box model shit */
.two {
    border-style: solid; //many options, default is hidden
    border-width: 2px; // or thin/medium/thick
    border-top-width: 1px; // or border-width: 1px 2px 3px 4px; clockwise
    border-radius: 10px; //curved borders
    visibility: hidden; // only hides the element, web page still renders the object
    display: none; // removes element from the web page. inline or inline-block like text wrapping
    padding: 1px;
    margin: 1px;
    box-sizing: border-box; // make padding and margins INSIDE the box
    }

/* Positioning stuff */
div.header {
    position: relative; // moves relative from def pos
    position: absolute; // pin element to page but disappear when scrolled
    position: fixed; // for headers, you want it always visible when scrolling
    z-index: 100; // "forwardsness", like bring-to-front
    float: left; // element can move as far left/right of page
    }

/* Images and stuff */
.btn {
    background-image: url("blah");
    width: 100%;
    background-repeat: no-repeat; // good idea
    display: block; // make it a block element to center
    margin: 0px auto;
    position: top-center;
    background-attachment: fixed; // the image doesn't move as you scroll
    background-size: cover; // basically fills it
    background-image: -webkit-linear-gradient(#666CCC, #BC1324); // instead of images,  gradients
}
```
