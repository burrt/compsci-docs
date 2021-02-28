---
layout: compsci-note
title: Hardware Caching Notes
categories: [hardware]
description: Some notes on cache architecture in hardware
order: 20
sitemap: false
---

## Methods of caching in hardware

1. [Direct Mapped](#direct-mapped)
2. [Fully Associative](#fully-associative)
3. [N-way Set Associative](#n-way-set-associative-cache)

## Basics

* Caches are configured in lines/blocks - contiguous memory
* Size of cache tag and data depends on its configuration
  * eg. [Block size] = Exploiting spatial/temporal locality? Miss rate? Latency?
  * Spatial = similar addresses, temporal = same block (time)
* Structure of cache depends on the type of cache, block size etc.

## Direct Mapped

For a 2<sup>N</sup> byte cache and 32 bit memory byte address and 2<sup>M</sup> byte block size:

* (32 - N) bits = cache tag (MSB)
* M bits = byte select
* (N - M) bits = index select

```text
Memory Address:
          32                 (32-N) (N-M)                M
          +------------------------+--------------------+--------+
          | Tag                    | Index              | Offset |
          +------------------------+--------------------+--------+

Cache Structure:
                                                  Block size
          +---+------------------------+---------+---------------+
Index 0 : | V | Tag                    | Index   | Byte 2^M | .. |
          +---+------------------------+---------+---------------+
Index 1 : | V | Tag                    | Index   | Byte 2^M | .. |
          +---+------------------------+---------+---------------+
...
```

* **Tag** = compare high bits with content of the cache
* **Index** = look at index of cache and compare tag with cache tag
* **Offset** = if block size  1 byte (...), index into cache data section

### Pros + Cons of direct mapped

* +Only need to compared **one** index
* +Simple check and eviction
* -Possibility of high collisions if block size and cache size aren't optimal
  * For example, if a program repeatedly accesses addresses > index, then the cache tag will be constantly **different** - cache thrashing

### Example: 1 KB direct mapped cache with 32 byte blocks/lines

* N = 10
* M = 5
* tag size = 22 bits
* index size =  5 bits
* offset size = 5 bits (size 32 bytes = 2^5)

```text
Memory Address:
          32                     10 9                  5 4       0
          +------------------------+--------------------+--------+
          | Tag                    | Index              | Offset |
          +------------------------+--------------------+--------+
```

## Fully Associative

* All cache locations can hold any data from any memory address
* +Removes conflicts
* -Need to compare all cache entries for match
  * High comparator cost
* -High cost of replacement policies to implement

```text
Memory Address:
          32                                             M
          +---------------------------------------------+--------+
     +----| Tag                                         | Offset |
     |    +---------------------------------------------+--------+
     |
     |
     |                                            Block size
     |    +----------------------------------+---+---------------+
    XOR --| Tag                              | V | Byte 2^M | .. |
     |    +----------------------------------+---+---------------+
    XOR --| Tag                              | V | Byte 2^M | .. |
     |    +---+------------------------------+---+---------------+
...
```

## N-way Set Associative Cache

Compared with direct mapped:

* `N` comparators vs `1`
* Extra MUX delay for the data
* Data comes **after** hit/miss decision and set selection
  * In direct mapped, data is available **before** hit/miss selection
* Fewer collisions since there are more lines available if there is a collision
* Complex comparison hardware - but at least it is more linear than number of cache lines
