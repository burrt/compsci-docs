---
layout: default
title: Linux Peripheral Notes
categories: [hardware, linux]
description: Some notes on Linux peripherals
order: 20
sitemap: false
---

# UART - Universal Asynchronous Receiver/Transmitter

* Translates between parallel and serial forms (eg. serial port, store in shift register)
* So data from a serial port can be stored in a buffer (before OS interrupts and attempts to read/flush this buffer)
* Can be either:
  * two/one way: simplex (one way)
  * full duplex (both devices can transfer)
  * half duplex (devices take turn in transfer)
* Data is basically buffered up and triggers interrupts to the OS and the OS determines whether to handle this data.
* This means that there may be data loss if the buffer overflows.

# Timers

* Is used to calibrate an OS's perception of time.
* Loops per jiffies
* Also triggers interrupts at a certain frequency.