---
layout: default
title: Visual Stuiod 2017 Notes
categories: [ide]
description: Some hotkeys and stuff for Visual Studio
order: 20
sitemap: false
---

# Visual Studio

## Hotkeys

```text
F5                  # start debugging, Shift + F5 to stop
F10                 # step over line, skip over function calls
F11                 # step into functions, initialisations as well
F12                 # go to definition, Shift + F12 will display results

Ctrl +/-            # navigate backwards (previous position)

Ctrl + F5           # start without debugging and set bp at end of main
Ctrl + Shift + B    # build solution

Ctrl + K, Ctrl + C  # comment out code block
Ctrl + C, Ctrl + V  # duplicate current line if nothing selected

Ctrl + K, Ctrl + F  # reformat selected
Ctrl + K, Ctrl + D  # reformat whole document

Ctrl + U            # lowercase
Ctrl + .            # show smart-tag menu - basically fix up popup

Ctrl + Shift + F    # displays find in files dialog
Ctrl + H            # replace
Ctrl + ,            # find file by name

Ctrl + M + O        # collapse all code sections
Ctrl + M + L        # expand all code sections

Ctrl + R, Ctrl + W  # show spaces
```

### Debugging

```text
Shift + F9  # opens QuickWatch
```

## Auto-complete

Abbreviations can be completed by typing then pressing Tab.

```text
cw     # generate Console.WriteLine, remove first paren for other method overloads
ctor   # generate a default constructor
testm  # generate a default test method
prop   # generate properties
for    # for loop with int i intializer etc.
```

## Misc

* Holding down `Alt` and dragging the cursor will allow box select
  * The cursor will also be spawned at the start of the cursor as well
