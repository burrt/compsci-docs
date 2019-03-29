---
layout: default
title: Memory Architecture Notes
categories: [memory]
description: Some notes on Memory Architectures
order: 20
sitemap: false
---

# Contents

* [Architectures](#architectures)
  * [Harvard](#harvard)
  * [von Neumann](#von-neumann)
* [Endianness](#endianness)
  * [Big Endian](#big-endian)
  * [Little Endian](#little-endian)
* [Memory hardware types](#memory-hardware-types)

## Terms

* **Access time**: is the time between when a read is *requested* and when the desired word arrives
* **Cycle time**: is the *minimum* time between requests to memory.
* `Cycle > access` when the memory needs the address lines to be stable between accesses e.g. DRAM refresh

## Architectures

### Harvard

* Separate storage and signal pathways for instructions and data.
* In a pure sense, it means that an instruction and data fetch can occur simultaneously.

#### Modified versions

This is really common and today's increasing use of a separate I-cache and D-cache whilst accessing the same main memory blur the lines of Harvard architecture.

## von Neumann

* The meaning has evolved to be any stored-program computer in which an instruction fetch and a data operation cannot occur at the same time because they share a common bus.
* This is referred to as the von Neumann bottleneck and often 'limits' the performance of the system.
* With the common use of caches, the distinction between the two is often blurred.

## Endianness

### Big Endian

* Big-End or MSB to low address
* Assuming byte aligned ie. if it were word aligned - there wouldn't be a change to the example below

```text
0x11223300 : aabbccdd // byte aligned

address     offset
            00 01 02 03
0x11223300: aa bb cc dd
```

### Little Endian

* Little-End or LSB to low address

```c
0x11223300 : aabbccdd  // byte aligned

address     offset
            00 01 02 03
0x11223300: dd cc bb aa
```

## Byte/word addressing

* Byte addressable:
  * Consider a 16–bit address space = 2^16 (65,536) addressable entities
* The maximum address space size would depend on the size of the addressable entity.
  * 8-bit Byte Addressable   64 KB  - each address = 1 byte
  * 16-bit Word Addressable  128 KB - each address = 2 bytes
  * 32-bit Word Addressable  256 KB - each address = 4 bytes

```c
// 8-bit Byte addressable
 -------------------------------
|  0x00 | 0x01  | 0x02  | 0x03  |
 -------------------------------

 // 16-bit word addressable
 -------------------------------
|       0x00    |      0x01     |  // so essentially 2*64K
 -------------------------------

 // 32-bit Word addressable
 -------------------------------
|             0x00              |  // so essentially 4*64K
 -------------------------------
```

## Memory hardware types

### DRAM

* Dynamic Random Access Memory - **volatile**
* Needs to be dynamically refreshed (uses only a single transistor - can be unstable) at a certain interval e.g. 8ms
* Access time > cycle time

### SRAM

* Static Random Access Memory
* Memory doesn't need to be refreshed since it uses 6 transistors to store a bit.
* This means that devices can enter a low power mode and SRAM itself needs very little power to retain its memory.

### Flash memory

* Flash doesn't need to be refreshed and is **non-volatile**.
* Its read-access times is comparable to DRAM however its write times can be 10-100 times slower.

#### NAND

* Read and written in blocks/pages.
* No longer random access and only via **sequential** access.
* Reduced erase and write times, and requires less chip area per cell, thus allowing *greater storage density* and lower cost per bit than NOR flash; it also has up to 10 times the endurance of NOR flash.
* Cells are connected in series.
  * **MLC**: Multi-level - less reliable and slower but can be mitigated through many strategies. There is enterprise NAND.
  * **SLC**:
  * **TLC**: used in Samsung 840?

#### NOR

* Read and written in bytes.
* Random access.
* Has long erase and write times and poor endurance - suitable for ROM.
* Cells are arranged in parallel, allowing erase/read of individual cells
