---
layout: compsci-note
title: ArchLinux Notes
categories: [linux]
description: Some notes on ArchLinux installation and stuff
order: 20
sitemap: false
---

# Contents

* [Fonts](#fonts)
* [Installation tips](#installation-tips)
* [Basics](#basics)

## Useful packages

* [archey3](https://wiki.archlinux.org/index.php/Archey3) - say no more
* [i3/i3status/i3lock](https://wiki.archlinux.org/index.php/i3) - personal preference, I like the window tiling
* [feh](https://wiki.archlinux.org/index.php/feh) - image viewer
* [gnome-screenshot](https://wiki.archlinux.org/index.php/taking_a_screenshot) - basic screenshot (no gnome dependencies)
* [foxitreader](https://aur.archlinux.org/packages/foxitreader/) - only use it for annotating pdf files, should use an alternative
* [screen](https://wiki.archlinux.org/index.php/GNU_Screen) - switch between terminal screens, like tabbing but better. Stop using haha.
* [bash-completion](https://wiki.archlinux.org/index.php/Bash#Tab_completion) - attempts to complete bash commands!
* [pkgfile](https://wiki.archlinux.org/index.php/pkgfile) - attempts to find the command/package if `Command not found` - combine with the `bashrc` to be useful

Many more but sometimes I forget about these packages so I listed them here.

Miscellaneous:

* [Bashrc customization](https://wiki.archlinux.org/index.php/User:Grufo/Color_System's_Bash_Prompt)

## Fonts

* Arch Linux gives me so much pain with fonts - especially with your configuration changes due to 'something'.
* User config is in `~/.config/fontconfig/fonts.conf`
* System wide is elsewhere and is usually overwritten.

## GTK

* If you're using GTK themes for Chromium/Firefox for example, they have their **own default fonts** - you need to change below!.
* You may have versions `2.0` and `3.0` installed, edit files:
  * `/usr/share/gtk-2.0/gtkrc`
  * `/usr/share/gtk-3.0/settings.ini`

### GTK+ 2

```bash
# ~/.gtkrc-2.0

gtk-icon-theme-name = "Adwaita"
gtk-theme-name = "Adwaita"
gtk-font-name = "DejaVu Sans 11"
```

### GTK+ 3

```bash
# $XDG_CONFIG_HOME/gtk-3.0/settings.ini

[Settings]
gtk-icon-theme-name = Adwaita
gtk-theme-name = Adwaita
gtk-font-name = DejaVu Sans 11
```

### Look out for

* So it took me a while why Chromium didn't default to `DejaVu Sans` despite what I had set:
  * `fontconfig` matched the correct family names.
    * I later attempted to default to `DejaVu Sans` without font family matching, this caused `monospace` fonts to not render e.g. code blocks were in `Sans` font...
  * Chromium Settings had `DejaVu Sans` set by default.
* Make sure to check if you're using a `GTK` or `GNOME` theme and what its font defaults are.

## Installing on a VM

For VMware workstation, some has documented the steps well.

* Change the boot options on the VM to EFI before booting
Follow this guide - [installing ArchLinux on VMware workstation](#https://chaseafterstart.github.io/#installing_arch_linux_on_vmware_workstation)
* Pay close attention when making the partition types: Microsoft Basic Data and Linux Filesystem
* Before executing `pacstrap` - remember to update your **mirrorlist** with a pacman mirrorlist generator

### VMware Tools

Useful for input peripherals and having the screen resolution auto adjust.

#### Windows resizing

```bash
# install open-vm-tools and not the official tools
pacman -S open-vm-tools

# some reports necessary
pacman -S gtkmm3

# potentially others
pacman -S gtk2 gtkmm

# check status vmtoolsd is enabled and running
systemctl enable vmtoolsd
systemctl start vmtoolsd
```

##### Last resort

Edit the `mkinitcpio.conf` file:

```conf
/etc/mkinitcpio.conf
MODULES="vsock vmw_vsock_vmci_transport vmw_balloon vmw_vmci vmwgfx"
```

And then run:

```bash
mkinitcpio -p linux
reboot
```

## Installation tips

* A few issues I had when installing Arch Linux for the ASUS Zenbook UX303LB-C4028H
* *Sorry for those thinking this was an installation guide - I didn't doc my steps before when I had so many issues with the official guide.*

### Partitioning

* When partitioning with `fdisk -l`
  * `fdisk /dev/sda/`
  * **Don't** include the number!
* When partitioning with `cfdisk`
  * Pay attention to the partition types as well
* When partitioning an EFI type, use:
  * `mkfs.fat -F32 /dev/sdb1`

### Getting some GUI

Don't we all want this...

```bash
pacman -S xorg-server

# to use startx
pacman -S xorg-xinit

# if you have command not found errors
pacman -S xterm
pacman -S i3-wm i3status dmenu

# if you don't have any fonts installed - i3 might look weird
pacman -S ttf-dejavu

# start xorg server
startx /usr/bin/i3
```

### Configuring X11

```bash
# if it doesn't exist
cp /etc/X11/xinit/xinitrc ~/.xinitrc
```

### Hotkey issues for laptops

* Install `acpilight` from AUR
* Not all the steps, it you're using `i3` as a WM, use its `bindsym` features to adjust `sys/proc`
  * Using `i3`, you can use their `bindsym`
* ~~Actually the latest updates seems to have fixed the brightness keys!!~~
* `xbacklight` can be used to adjust them manually

### Autologin

* Create a new service file similar to `getty@.service` by copying it to `/etc/systemd/system/`
  * `cp /usr/lib/systemd/system/getty@.service /etc/systemd/system/autologin@.service`
* You will then have to symlink that `autologin@.service` to the getty service for the tty on which
  you want to autologin, for examply for tty1:
  * `ln -s /etc/systemd/system/autologin@.service /etc/systemd/system/getty.target.wants/getty@tty1.service`
* Modify `autologin@.service` and reload daemon files, start service

```bash
ExecStart=-/sbin/agetty --autologin gcho300 --noclear -s %I 115200,38400,9600 $TERM
systemctl daemon-reload
systemctl start getty@tty1.service
```

* Somewhere an argument isn't happy
* Auto `startx` for tty1 in `~/.bash_profile`

```bash
if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
  exec startx /usr/bin/i3
fi
```


## Basics

```bash
sudo wifi-menu -o
# generate profile to /etc/netctl
# and hash the password
```

### xrandr

Set the resolutions

```bash
xrandr --output HDMI1 --mode 1920x1080_60.00
xrandr --output HDMI1 --mode 1920x1080 --rate 60
# don't attempt to turn off a laptop screen...
```

### dotfiles

* `/etc/bash.bashrc` initializes variables for interactive shells only. It also runs scripts but (as its name implies) is Bash specific.
* `/etc/environment` is used by the `PAM-env` module and is **agnostic** to login/non-login, interactive/non-interactive and also Bash/non-Bash, so scripting or glob expansion cannot be used. The file only accepts variable=value pairs.

### .bash_profile

* Bash is invoked as a **login shell**, it reads `/etc/profile` first, then others like `.bash_profile`, `.bash_login`
* Now `.bash_profile` is useful for:
  * If you want specific programs to run at the login shell and **not** every time you run `bash`
  * Transient settings and aliases/functions which are **not** inherited are put in `.bashrc` so that they can be re-read by every new interactive shell.
  * Place `env` variables here, they will be inherited by child processes of fork() from the initial `BASH`

## UNSW

### netctl

* Problems connecting to `uniwide` and `eduroam` with their auth methods - this is when I wished I still ran Linux Mint!

```bash
Description='UNSW WIFI Uniwide'
Interface=wlp2s0
Connection=wireless
Security=wpa-configsection
ESSID=uniwide
IP=dhcp
WPAConfigSection=(
	'ssid="uniwide"'
	'key_mgmt=WPA-EAP'
	'eap=PEAP'
	'pairwise=TKIP CCMP'
	'phase2="auth=MSCHAPV2"'
	'identity="z1234567"'
	'password="pass"'
	)
```