---
layout: compsci-note
title: Raspberry Pi 3 Notes
categories: [raspberry-pi]
description: Some notes for configuring my Raspberry Pi 3
---

## Raspberry Pi 3

### Specifications

* SoC: Broadcom BCM2837
* CPU: 4× ARM Cortex-A53, 1.2GHz
* GPU: Broadcom VideoCore IV
* RAM: 1GB LPDDR2 (900 MHz)
* Networking: 10/100 Ethernet, 2.4GHz 802.11n wireless
* Bluetooth: Bluetooth 4.1 Classic, Bluetooth Low Energy
* Storage: microSD
* GPIO: 40-pin header, populated
* Ports: 
  * HDMI
  * 3.5mm analogue audio-video jack
  * 4× USB 2.0
  * Ethernet
  * Camera Serial Interface (CSI)
  * Display Serial Interface (DSI)

## Raspberry Pi 3 B+

### Specifications

* Quad Core 1.2GHz Broadcom BCM2837 64bit CPU
* 1GB RAM
* BCM43438 wireless LAN and Bluetooth Low Energy (BLE) on board
* 100 Base Ethernet
* 40-pin extended GPIO
* 4 USB 2 ports
* 4 Pole stereo output and composite video port
* Full size HDMI
* CSI camera port for connecting a Raspberry Pi camera
* DSI display port for connecting a Raspberry Pi touchscreen display
* Micro SD port for loading your operating system and storing data
* Upgraded switched Micro USB power source up to 2.5A

## Raspbian

Useful bootstrapping stuff:

```bash
# You can configure hostname, networking, keyboard, locale etc.
raspi-config
```

A lot is covered by the [Raspberry Pi documentation](https://www.raspberrypi.org/documentation/configuration/) which is really awesome.

### Troubleshooting

If you wrecked your `fstab` and booted in Emergency Mode - see http://clarkle.com/notes/emergecy-mode-bad-fstab/.

### Disabling the Wifi

```bash
sudo iwconfig wlan0 txpower off
```

### Static IP Address

See [this StackOverflow post](https://raspberrypi.stackexchange.com/questions/37920/how-do-i-set-up-networking-wifi-static-ip-address/74428#74428).

## NAS

Some links to look at for setting a NAS on Raspbian:

* https://github.com/sebschlicht/backupnas/wiki/HowTo:-Setup-a-NAS-using-Samba
* https://linuxhint.com/setup_nas_server_rasperberry_pi/
