---
layout: compsci-note
title: Powershell Notes
categories: [scripting]
description: Some notes on Powershell which I never use
sitemap: false
---

## Contents

## Basics

```powershell
Get-Alias ls
Get-Help Get-Content -Full  # Help Get-Content
Get-Command *GPO*           # gcm *gpo*
Get-Process | Get-Member    # Get-Process | gm

# Interactive sessions
Enter-PSSession SomeServer
Exit-PSSession

# Run a remote command
Invoke-Command -ComputerName Server01, Server02 -ScriptBlock {Get-UICulture}

# Run a script
Invoke-Command -ComputerName Server01, Server02 -FilePath c:\Scripts\DiskCollect.ps1

# Show all the properties of an object
Get-Member

# Access the value of a member
Get-Date | Select-Object -Property Day

# Creating your own property and naming it
get-service | select-object -property @{N='MyNewStatus';E={$_.Status}}, @{N='MyNewName';E={$_.Name}}

```

## Special characters

| Special character | Meaning                               |
|-------------------|---------------------------------------|
| `"`               | The beginning (or end) of quoted text |
| `#`               | The beginning of a comment            |
| `$`               | The beginning of a variable           |
| `&`               | Reserved for future use               |
| `( )`             | Parentheses used for sub-expressions  |
| `;`               | Statement separator                   |
| `{ }`             | Script block                          |
| `|`               | Pipeline separator                    |
|`` ` ``            | Escape character                      |

## Comparisons

| Comparator                                 | Explanation                                                        |
|--------------------------------------------|--------------------------------------------------------------------|
| `-eq`, `-ne`, `-ceq`, `-cne`               | Equality case insensitive and sensitive                            |
| `-lt`, `-gt`                               | Less, greater than                                                 |
| `-le`, `-ge`                               | Less than or equal to, greater than or equal to                    |
| `-and`, `-or`                              | Basic AND/OR                                                       |
| `-not`, `!`                                | NOT                                                                |
| `-like`, `-notlike`, `-clike`, `-cnotlike` | Wildcard case (in)sensitive equality                               |
| `-match`, `-cmatch`                        | Regex string matching with case sensitivity - returns as a boolean |
