---
layout: compsci-note
title: REST Architecture Notes
categories: [fundamentals, architecture]
description: Some notes on the REST architecture
---

## REST

From [Wikipedia](https://en.wikipedia.org/wiki/Representational_state_transfer):

> **Representational State Transfer** is a common standard for a software architecture for interactive applications that typically use multiple Web services.
>
> A *RESTful* Web service is when certain constraints of the REST architecture are met. It is required to provide an application access to its Web resources in a textual representation e.g. JSON, and support reading and modification of them with a stateless protocol and a predefined set of operations. REST offers an alternative to, for instance, SOAP as a method of access to a Web service.

Web resources are usually identified by their **URLs**. Requests made to a resources URI against a RESTful Web service will elicit a response with a payload formatted in HTML/XML/JSON/other format. The application layer protocol HTTP is often used as the stateless protocol for RESTful Web services, usually over TCP (network layer) which most browsers support.

## Constraints

1. Client-server architecture
    * Separating the user interface and data storage concerns allows portability of the user interfaces across multiple platforms as well as performance optimizations.
2. Statelessness
    * *Intrinsic* state is stored on the server and consists of information that is independent of the server's context - thereby making it sharable to all clients of the server.
    * *Extrinsic* state is application state and is stored on the client side. It consists of information that is dependent on the server's context and therefore cannot be shared.
    * Storing application state on the client rather than on the server makes the communication stateless.
3. Cacheability
    * Responses must define themselves whether they are cacheable or not to prevent clients from providing stale/inappropriate data in response to further requests
4. Layered system
    * A client cannot tell whether it is connected directly to the end server or to an intermediary along the way e.g. a proxy or load balancer can be placed between the client and server and it won't affect their communications.
5. Uniform interface
    * **Resource identifiers in requests** e.g. URIs. The resources are conceptually separate from the representations that are returned to the client i.e. the server's representation of the object returned in a textual format to the client is inherently different.
    * When a client holds a representation of a resource, including any metadata attached, it has enough information to modify or delete the resource's state.
    * Each message includes enough information to describe how to process the message. For example, which parser to invoke can be specified by a media type.
    * **HATEOAS** - Hypermedia as the Engine of Application State - having access an initial URI for the rest application, the client should be able to *dynamically* discover all other available resources it needs.
6. Code on demand (optional)
    * The server can temporarily extend/customize the functionality of a client by transferring executable code e.g. client-side scripts such as JavaScript.

### URL vs URI

A Uniform Resource Locator is a reference to a web resource that specifies its location on a computer network and a mechanism for retrieving it. A URL is a specific type of Uniform Resource Identifier (URI) - therefore all URLs are URIs.

URLs most commonly reference web pages (HTTP) but there are also used for file transfer (FTP), email (mailto), database access (JDBC) etc.

Every URL conforms to the syntax of a generic URI: `URI = scheme:[//authority]path[?query][#fragment]`

URIs are a standard for identifying documents using a short string of numbers, letters, and symbols. A URI identifies, a URL identifies and locates it. For example `urn:isbn:0451450523`, the URI could be be resolved to a URL and subsequently an operation could be performed against it.

### SOAP vs REST

Simple Object Access Protocol is a protocol whilst REST is an architectural style and is not a standard itself.

>SOAP is a messaging protocol specification for exchanging structured information in the implementation of Web services. It uses XML Information Set for its message format and relies on application layer protocols such as HTTP for message negotiation and transmission.

### Additional Reading

* [Stack Overflow - What is RESTful programming?](https://stackoverflow.com/questions/671118/what-exactly-is-restful-programming)
* [Stack Overflow - What's the difference between REST and RESTful?](https://stackoverflow.com/questions/1568834/whats-the-difference-between-rest-restful)
