---
layout: compsci-note
title: Emacs Notes
categories: [ide]
description: Some hotkeys of Emacs I always forget
order: 20
sitemap: false
---

```text
==============================================================================
emacs
==============================================================================

Meta keys: (Alt Option  Esc Edit)
-----------------------------------------------------------------------
Save                                    | C-x C-s
Quit                                    | C-x C-c
To quit a partially entered command     | C-g
Open/Find a file                        | C-x C-f or C-x d (for Dired)

-----------------------------------------------------------------------
Copy text                               | M-w
Copy line                               | C-c C-k
Cut text                                | C-w
Paste                                   | C-y
Undo                                    | C-x u  or C-/
Redo                                    | C-g C-/ or C-x C-/ or C-? if undo-tree-mode
Go to line                              | M-g g

Select text- sets the marker            | C-<SPACE>
Select text - up/down                   | up / down keys / C-up/down

Delete line from cursor                 | C-k
Delete word infront of cursor           | M-d
Delete word behind of cursor - freq     | M-<DEL>

Search for word - display list          | M-s o | "\bword\b" to bound it
Search for word                         | M-s w
Search forward/backward                 | C-s / C-r

Convert region to lower case (downcase-region).   | C-x C-l
Convert region to upper case (upcase-region).     | C-x C-u

-----------------------------------------------------------------------
Moving to the previous line             | C-p (p for Previous)

Moving to the beginning of the file     | M-< (Alt + Shift + "<")
Moving to the end of the file           | M-> (Alt + Shift + ">")

-----------------------------------------------------------------------
File navigation
-----------------------------------------------------------------------
Find a file - arg                       | C-x C-f <TAB> for auto-complete

-----------------------------------------------------------------------
Creating TAGS
-----------------------------------------------------------------------
rm -f TAGS                              | delete any current TAGS
ctags -e -R .                           | creates TAGS for all support file types

-----------------------------------------------------------------------
General navigation
-----------------------------------------------------------------------

List buffers                            | C-x C-b
Kill buffer                             | C-x k
Remove buffer list                      | C-x 1
Search / select from buffer list        | C-x b <buffer_name>
Save all buffers                        | C-x s
```