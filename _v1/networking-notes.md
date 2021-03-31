---
layout: compsci-note
title: Networking Notes
categories: [networks]
description: Some notes on Networking
sitemap: false
favorite: true
---

## Contents

* [Protocols](#protocols)
* [DNS](#dns)
* [Network Security](#network-security)
  * [SSL](#ssl)
* [Proxy](#proxy)

## Basics

### Glossary

| Term        | Explanation                                                                     |
|-------------|---------------------------------------------------------------------------------|
| Zone file   | Where all DNS records are stored                                                |
| Host record | Domain you which to use. the `@` symbol indicates the root domain.              |
| TTL         | Time to Live indicates the amount of time the record is cached by a DNS server. |
| Tunnelling  | Is the delivery of one protocol on top of a protocol of similar or higher layer e.g. TCP on IP on Ethernet. For VPNs for example, the TCP/IP packets containing the HTTP session would be carried in a distinct TCP/UDP/IP stream between the VPN endpoints. This portion of the trip would be HTTP on TCP/IP on IPSec on UDP/IP on Ethernet|

### TCP vs UDP

UDP is a connection-less transport protocol that has no reliability guarantees of the packets transmitted. TCP is connection orientated and provides reliable flow of data between two systems.

### OSI

The Open Systems Interconnection model (OSI model) is a conceptual model that characterizes and standardizes the communication functions of a telecommunication or computing system without regard to its underlying internal structure and technology. Its goal is the interoperability of diverse communication systems with standard protocols. The model partitions a communication system into abstraction layers. The original version of the model defined seven layers.

| Layer           | Protocol data unit (PDU) | Function                                                                                                                                                                                               |
|-----------------|--------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| 7. Application  | Data                     | High-level APIs, including resource sharing, remote file access e.g. HTTP, SMTP,FTP                                                                                                                    |
| 6. Presentation | Data                     | Translation of data between a networking service and an application; including character encoding, data compression and encryption/decryption                                                          |
| 5. Session      | Data                     | Managing communication sessions, i.e. continuous exchange of information in the form of multiple back-and-forth transmissions between two nodes.                                                       |
| 4. Transport    | Segment, Datagram        | Reliable transmission of data segments between points on a network, including segmentation, acknowledgement and multiplexing. TCP/UDP etc.                                                             |
| 3. Network      | Packet                   | Structuring and managing a multi-node network, including addressing, routing and traffic control. Transferring packets between nodes and is dominated by the Internet Protocol (IP). e.g. IP, routers  |
| 2. Data link    | Frame                    | Reliable transmission of data frames between two nodes connected by a physical layer. MAC/LLC layer e.g. 802.3 Ethernet, 802.15.4 ZigBee operate at the data link layer. Ethernet, switches.           |
| 1. Physical     | Symbol                   | Transmission and reception of raw bit streams over a physical medium. Cables etc.                                                                                                                      |

#### TCP/IP Model

It's essentially the same with the exception the application, presentation and session layers are merged into just the application layer. This results in 5 layers and below is an example of the internet data flow starting at the application layer:

1. It is treated as just data - data
2. The transport information is added - TCP + data
    * TCP information includes source and destination ports, sequence numbers and so on
3. The IP information is added - IP + TCP + data
    * Source and destination IP addresses
4. Ethernet header and trailer added - Ethernet + IP + TCP + data + Ethernet
    * Source and destination MAC address, and also error-checking information
5. Physical layer transfers the symbol.

### Proxy servers

Also known as application-level gateway, is a machine that acts as a gateway between a local network and a larger scale network e.g. the Internet. They intercept connections between the sender and receiver (Layer 4 or higher) and can block, forward to different ports etc. They aren't as robust like VPNs where it can secure your traffic and proxies are **application based** - not device level.

It connects to, responds to, and receives traffic from the internet - acting on behalf of the client computer. Whilst a NAT device will transparently change the origin address traffic going through it before passing it to the internet. NAT operates at the Layer 3 (Network).

### Protocols

#### HTTP

Hypertext Transfer Protocol is an application layer protocol for distributed, collaborative, hypermedia information systems. It is commonly used to access hypertext documents which include hyperlinks to other resources they too can be accessed and so on.

HTTP functions as a request-response protocol in a client-server computing model. For example, a client submits an HTTP request message to the server which provides resources such as HTML files and other content, or performs other functions on behalf ot he client, returns a response to the client.

HTTP/1.1 has improvements such as streaming content by chunked transfer encoding, persistent connections (keep-alive mechanism) and connection reuse. HTTP/3 uses QUIC instead of TCP and it aims to address HTTP/2 performance concerns.

#### HTTPS

HTTPS is an extension of the HTTP protocol by securing the protocol with TLS. HTTPS listens on port 443 by default. It aims to provide authentication, privacy and integrity of the data that is exchanged with the server - protection against MIM.

Most of the internet traffic uses HTTPS and since SSL/TLS can still provide some protection with only one side of the communication authenticated (the client authenticates the server's certificate).

#### SSH

Secure Shell (SSH) is a cryptographic network protocol for operating network services securely over an unsecured network.

>SSH uses public-key cryptography to authenticate the remote computer and allow it to authenticate the user, if necessary. There are several ways to use SSH; one is to use automatically generated public-private key pairs to simply encrypt a network connection, and then use password authentication to log on.
>
>Another is to use a manually generated public-private key pair to perform the authentication, allowing users or programs to log in without having to specify a password. In this scenario, anyone can produce a matching pair of different keys (public and private). The public key is placed on all computers that must allow access to the owner of the matching private key (the owner keeps the private key secret). While authentication is based on the private key, the key itself is never transferred through the network during authentication. SSH only verifies whether the same person offering the public key also owns the matching private key. In all versions of SSH it is important to verify unknown public keys, i.e. associate the public keys with identities, before accepting them as valid. Accepting an attacker's public key without validation will authorize an unauthorized attacker as a valid user.

## DNS

The Domain Name System (DNS) is a hierarchical, distributed database that contains mappings between names and other information, such as IP addresses.

DNS allows users to locate resources on the network by converting friendly, human-readable names like www.microsoft.com to IP addresses that computers can connect to.

### DNS Records

| Record   | Description                                                                                                                                                                                                                         |
|----------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| A        | Address record - points a domain to an IP address e.g. an A record with `store.website.com` can be pointed to where you have your store.                                                                                            |
| CNAME    | Canonical name - points one domain to another domain. This is useful to only ever having to change **one** A record and have your CNAME records point to it. It **must** point to a domain and **never** directly to an IP address. |
| MX Entry | Mail Exchange entry directs email to a particular mail server. It **must** point to a domain and **never** directly to an IP address.                                                                                               |
| TXT      | Text record - originally intended for human-readable text. The TXT value is what the record points to and provides information for outside sources. Example use cases are SPF and DomainKeys.                                       |
| SRV      | Service record - points domain to another domain using a specific destination port. It allows specific services such as VOIP/IM to be directed to a separate location.                                                              |
| AAAA     | Similar to A record but allows you to point the domain to an IPv6 address.                                                                                                                                                          |

### DNS Resolution

1. An application uses the `DnsQuery()` API or the `GetAddrInfo()` or `GetHostByName()` Windows Sockets APIs to resolve a name.

2. If the name is a flat name, the DNS Client service creates an FQDN using configured DNS suffixes.

3. It then performs the following checks in order:
    1. The DNS Client service checks the DNS resolver cache for the FQDN, which contains the entries in the Hosts file and the results of recent positive and negative name queries. If an entry is found, the result is used and no further processing occurs.

    2. Next the [NRPT](#nrpt) table is checked
        * The DNS Client service passes the FQDN through the NRPT to determine the rules in which the FQDN matches the namespace of the rule.
        * NRPT Stands for Name Resolution Policy Table and is the first location that is checked.
        * If a Match is found, No further processing is done and the DNS Server/Proxy server in the NRPT table is used to query for the address
        * Now if resolution fails and if the user on a Private Network, the resolution will fall back to the interface

    3. Finally if no match is found we go to the Interface directly.
        * If the FQDN does not match any rules, or matches a single rule that is an exemption rule, the DNS Client service attempts to resolve the FQDN using interface-configured DNS servers. How this works is the following;

            * The interface with the lowest metric is checked first
            * What would happen in this situation that DNS would take the hostname, append the DNS Suffix for the first interface that matches, send a DNS query on it. If fails, move to the next.
            * If the FQDN matches a single rule that is not an exemption rule, the DNS Client service applies the specified special handling.
            * If the FQDN matches multiple rules, the DNS Client services sorts the matching rules for precedence—in order: FQDN, longest matching prefix, longest matching suffix [including IPv4 and IPv6 subnets], any—to determine the rule that most closely matches the FQDN.
            * After determining the closest matching rule, the DNS Client service applies the specified special handling.

### NRPT

The Name Resolution Policy Table (NRPT) is a table of namespaces and corresponding settings stored in the Windows Registry that determines the DNS client's behavior when issuing queries and processing responses.

Each row in the NRPT represents a rule for a portion of the namespace for which the DNS client issues queries. Before issuing name resolution queries, the DNS client will consult the NRPT to determine if any additional flags must be set in the query. Upon receiving the response, the client will again consult the NRPT to determine any special processing or policy requirements.

In the absence of the NRPT, the client will operate in a normal fashion. The NRPT stores configurations and settings that are used to deploy DNS Security Extensions (DNSSEC), and also stores information related to DirectAccess, a remote access technology.

![DNS Queries with NRPT](https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2008-R2-and-2008/images/ee649207.6e6df08d-e704-4222-a0ed-d8c34cdcc5b4%28ws.10%29.gif)

### DNSSEC

Domain Name System Security Extensions (DNSSEC) is a suite of extensions that add security to the DNS protocol.Specifically, DNSSEC provides origin authority, data integrity, and authenticated denial of existence.

To read more about DNS threats, the [MS Docs](https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2008-R2-and-2008/ee649205(v%3dws.10)#dns-threats-and-security) covers it pretty well.

To read more about DNSSEC, see the [MS Docs](https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2012-R2-and-2012/jj200221%28v%3dws.11%29) as well.

## Network security

The desirable forms of secure communication would be to ensure we have:

* Confidentiality - snooping/MIM
* Integrity - tampering
* Authentication
* Operational security - firewalls

### SSL

Secure Sockets Layer (SSL and now largely deprecated) and Transport Layer Security (TLS) enhance TCP with security services such as including confidentiality, data integrity and end-point authentication (client & server).

SSL technically resides in the **application** layer - but most developers will use it as if it were a transport-layer protocol.

```text
+-------------+
| Application |
++-----------++
 |TCP socket |
++-----------++
| TCP         |
++-----------++
| IP          |
+-------------+
| Data        |
+-------------+
| Physical    |
+-------------+
//
// Dev view as TCP API
//

+-------------+
| Application |
++-----------++
 |SSL socket |
++-----------++
| SSL sublayer|
++-----------++
 |TCP socket |
++-----------++
| TCP         |
++-----------++
| IP          |
+-------------+
| Data        |
+-------------+
| Physical    |
+-------------+
//
// TCP enhanced with SSL
//
```

#### Handshake overview

Say Bob and Alice needs to securely communicate:

1. B -> A: TCP SYN
2. A -> B: TCP/SYNACK
3. B -> A: TCP ACK
4. B -> A: SSL hello
    * This step is to verify Alice's identity
5. A -> B: Alice's Certificate
    * Remember, this has her public key embedded
    * Bob can verify her identity with a trusted CA
6. B -> A: Creates Master Secret (MS)
    * Encrypts it with Alice's public key
    * EMS = K<sup>+</sup><sub>A</sub>(MS)
7. Alice can not use her private key K<sup>-</sup><sub>A</sub> to decrypt the EMS to use the MS (session key) for data transfer.

#### Master Secret Key

In reality, the MS is a bit more complicated but essentially it the MS will be used to generate 4 keys:

1. E<sub>B</sub> - session data encryption key (data confidentiality)
2. M<sub>B</sub> - session MAC key (data integrity)
3. E<sub>A</sub>
4. M<sub>A</sub>

Notice the keys are **not** bi-directional.

### IPSec

Internet Protocol Security (IPSec) is a secure network protocol suite that authenticates and encrypts the packets of data sent over the IP network. It is used in virtual private networks.

It can operate in two modes:

1. **Transport mode**: only the payload of the IP packet is usually encrypted/authenticated. The IP header isn't modified or encrypted. The tunnel that is created can be L2TP for example - which establishes end-to-end security. This isn't always possible with firewalls for example.
2. **Tunnel mode**: the entire IP packet is encrypted and authenticated. It is then encapsulated into a new IP packet and new IP header. It is used for VPNs for network-to-network communications, host-to-network (and vice versa) communications. This could involve many tunnels being created between gateways and un-wrapping and wrapping of the IP packet occurs to avoid build-up.
    * Interestingly, with the original IPv4 packet encapsulated in the IPSec packet, the endpoint doesn't need to be aware that IPSec is in play.
    * Also, the new IPSec packet is addressed at the interface layer and **not** the original IPv4 ports/addresses e.g. TCP Port 80.

### VPN

>A virtual private network (VPN) extends a private network across a public network, and enables users to send and receive data across shared or public networks as if their computing devices were directly connected to the private network.
> \- [Wikipedia](https://en.wikipedia.org/wiki/Virtual_private_network)

A VPN client is installed on the machine and connects to the VPN server. All traffic, not per-application base but at the OS level, is then communicated in the encrypted channel to the VPN server. At the VPN server, it will then resolve the original requests via an un-encrypted channel.

There are a few VPN protocols:

* OpenVPN
* L2TP/IPsec - Layer 2 Tunneling Protocol
* SSTP - Secure Socket Tunneling Protocol
* IKEv2 - Internet Key Exchange v2
* PPTP - Point to Point Tunneling Protocol

## Proxy

Summarized from [Cloudflare](https://www.cloudflare.com/en-au/learning/cdn/glossary/reverse-proxy/).

### Forward Proxy

A forward proxy (proxy/proxy server/web proxy) is when a server sits **in front** of a group of **client machines**. When clients make requests to sites on the Internet, the proxy intercepts those requests and communicates with web servers on behalf of those clients - like MIM.

These are often used on a per-application basis for hiding IP addresses, restricting content, bypass firewalls etc.

### Reverse Proxy

A reverse proxy is instead a server that sits **in front** of one or more **web servers**. Requests from the Internet are intercepted and then delegated to a particular server. This is common for load balancers, caching, API gateways etc.
