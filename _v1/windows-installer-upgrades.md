---
layout: compsci-note
title: Windows Installer Upgrades Notes
categories: [windows, windows-installer]
description: Some notes on Windows Installer Upgrades
---

## Contents

* [Versioning](#versioning)
* [Upgrades Overview](#upgrades-overview)
* [Major upgrades](#major-upgrades)
  * [Upgrade Conditions](#upgrade-conditions)
  * [WiX MajorUpgrade Element](#wix-majorupgrade-element)
* [Minor upgrades](#minor-upgrades)
* [Small upgrades](#small-updates)

## Overview

This is a huge topic and I am no expert on this. There are many articles floating around about Windows Installer upgrades which most conclude with: stick with **major upgrades** if you can. It comes to no surprise from the developer community to look for alternatives to software lifecycle management due to the sheer complexity and unforeseen problems with Windows Installer upgrades.

## Resources

* [Small and minor upgrade problems](http://windows-installer-xml-wix-toolset.687559.n2.nabble.com/Small-and-Minor-updates-again-td1661960.html) - something about `QFEUpgrade` property that has almost no documentation
* [Another small and minor upgrades problems](https://www.mail-archive.com/wix-users@lists.sourceforge.net/msg21173.html) - another concern with CA conditions
* [MS Docs: Patches and upgrades](https://docs.microsoft.com/en-us/windows/desktop/Msi/patching-and-upgrades)
* [MS Docs: creating patches](https://docs.microsoft.com/en-us/windows/desktop/Msi/creating-a-small-update-patch)
* [WiX Patchwork](https://www.firegiant.com/wix/tutorial/upgrades-and-modularization/patchwork/)

## Versioning

The standard version convention is:

| Major | . | Minor | . | Build | . | Revision |
|-------|---|-------|---|-------|---|----------|
| 8bit  | . | 8bit  | . | 16bit | . | 16bit    |
| 255   | . | 255   | . | 65535 | . | 65535    |

It is common for versioning to deviate and where the `build` and `revision` are swapped. Then in CI/CD pipelines, the build number will be incremented. It is a loose convention.

## Upgrades Overview

What is changes are required for upgrades:

| Upgrade type  | Package code | Product version | Product code | Upgrade code |
|---------------|--------------|-----------------|--------------|--------------|
| Small Update  | X            |                 |              |              |
| Minor Upgrade | X            | X               |              |              |
| Major Upgrade | X            | X               | X            |              |

A really helpful [table that suggests doing a certain type of upgrade](http://helpnet.flexerasoftware.com/installshield22helplib/helplibrary/MajorMinorSmall.htm) is important to read about - most forums and posts recommend **only major upgrades**. You want to test your installer upgrades before you ship your first product.

The WiX package code is an auto-generated GUID that changes on each build unless you're compiling a merge module - this can be left as is.

> Note that you always have to change the Package GUID when you create a new `.msi` file that is different from the previous ones in any respect. The Installer keeps track of your installed programs and finds them when the user wants to change or remove the installation using these GUIDs.
>
>Using the same GUID for different packages will confuse the Installer.

## Upgrade checks

It is important for the installer to check if the same product version is already installed or a newer one is. Be sure to abort the installation if the criteria isn't met:

```xml
<Upgrade Id='YOURGUID-7349-453F-94F6-BCB5110BA4FD'>

    <!--
        Meaning: SELFFOUND = productVersion <= detectedVersion <= productVersion

        WIX_UPGRADE_DETECTED is automatically added by the WiX Toolset.
    -->
    <UpgradeVersion OnlyDetect='yes' Property='SELFFOUND'
        Minimum='$(var.ProductVersion)' IncludeMinimum='yes'
        Maximum='$(var.ProductVersion)' IncludeMaximum='yes' />

    <!-- Meaning: NEWERFOUND = detectedVersion > productVersion -->
    <UpgradeVersion OnlyDetect='yes' Property='NEWERFOUND'
        Minimum='$(var.ProductVersion)' IncludeMinimum='no' />
</Upgrade>
```

You then need to create some custom actions and modify the `InstallExecuteSequence` to make use of the properties that were set in the above `Upgrade` node:

```xml
<!-- Define custom actions to be evaluated by the above properties -->
<CustomAction Id='AlreadyUpdated' Error='Foobar 1.0 has already been updated to $(var.ProductVersion) or newer.' />
<CustomAction Id='NoDowngrade' Error='A later version of [ProductName] is already installed.' />

<!-- Modify the InstallExecuteSequence so that the custom actions are triggered after FindRelatedProducts -->
<InstallExecuteSequence>
    <Custom Action='AlreadyUpdated' After='FindRelatedProducts'>SELFFOUND</Custom>
    <Custom Action='NoDowngrade' After='FindRelatedProducts'>NEWERFOUND</Custom>
</InstallExecuteSequence>
```

## Major Upgrades

* A typical major upgrade removes a previous version of an application and installs a new version.
* A major upgrade can reorganize the feature component tree.
* During a major upgrade using Windows Installer, the installer searches the user's computer for applications that are related to the pending upgrade, and when it detects one, it retrieves the version of the installed application from the system registry.
* The installer then uses information in the upgrade database to determine whether to upgrade the installed application.

This is generally recommended by most people including the WiX developers - there's even built-in support to make major upgrades much easier to deal with. Although there is a *cost* involved, there is far less undefined or unexpected behavior.

### Steps for major upgrades

1. Leave the `UpgradeCode` unchanged
2. Change the `Description` if needed
3. Change the `Version` number (first three parts) e.g. `1.0.0` to `1.2.0`
4. Change the `Product/@Id`, else let WiX auto-generate using `Id="*"`
5. Test the upgrades

Test scenario 1:

* Install v1
* Install v2
* Verify v1 files are removed and v2 works expectedly
* Verify files that needed to be upgraded and added in v2

Test scenario 2:

* Install v2
* Verify install v1 fails

Pay attention to assemblies that need to be installed to the GAC or the Win32 WinSxS store. There is some information about a sequence of events that can remove assemblies from the GAC and the WinSxS store during some major upgrades in this [KB article](http://support.microsoft.com/kb/905238).

It would be ideal to test upgrades as part of the CI/CD pipelines - BG compatibility etc.

### Upgrade conditions

Remember, a **major upgrade** consists of two parts: uninstalling the old product and then installing the new product.

You might want to be aware of these important MSI properties:

1. `UPGRADINGPRODUCTCODE` - see [MS Docs](https://msdn.microsoft.com/en-us/library/windows/desktop/aa372380(v=vs.85).aspx)
    * Set during uninstall of *old* product
2. `WIX_UPGRADE_DETECTED` - see [WiX Docs](http://wixtoolset.org/documentation/manual/v3/xsd/wix/majorupgrade.html)
    * Set during install of *new* product for an upgrade

| Installation Type | MSI Condition                                |
|-------------------|----------------------------------------------|
| Major Upgrade     | `WIX_UPGRADE_DETECTED`                       |
| Clean install     | `NOT Installed AND NOT WIX_UPGRADE_DETECTED` |
| Uninstall         | `REMOVE="ALL" AND NOT UPGRADINGPRODUCTCODE`  |

### WiX MajorUpgrade element

The WiX `MajorUpgrade` element allows the re-scheduling of the `RemoveExistingProducts` action. This will change the state of the machine and ultimately the behavior of the upgrade. Be sure to read it carefully.

See [MajorUpgrade/@Schedule](https://wixtoolset.org/documentation/manual/v3/xsd/wix/majorupgrade.html):

>`afterInstallInitialize`
>
>Schedules `RemoveExistingProducts` after the `InstallInitialize` standard action. This is similar to the `afterInstallValidate` scheduling, but if the installation of the upgrade product fails, Windows Installer also rolls back the removal of the installed product -- in other words, reinstalls it.
>
>i.e. if the new product version fails (and rolls-back its changes) - the old product version remains on the machine.

## Minor Upgrades

* A minor upgrade can be used to add new features and components but cannot reorganize the feature-component tree.
* Minor upgrades provide product differentiation without actually defining a different product.
* A typical minor upgrade includes all fixes in previous small updates combined into a patch.
* A minor upgrade is also commonly referred to as a service pack (SP) update.

>If you want to ship updates as MSP's (Small Update or Minor Upgrade in Microsoft terminology) **don't** use auto-generated GUIDs.
>
>If you're only ever going to ship updates as MSI's (Major Upgrades) you need to change the Product Code every time anyway so auto-generating is fine.

Minor upgrades are generally **not** recommended and many people have encountered issues - e.g. [mixing minor and major upgrades](https://wix.ronifuchs.com/tag/minor-upgrade/). There is a trade-off of [cost](http://www.joyofsetup.com/2008/12/30/paying-for-upgrades/) (reinstalling a product may take a long time), complexity and size.

### Steps for minor upgrades

The steps for a minor upgrade:

1. Leave `UpgradeCode` and `Product/@Id` unchanged
2. Increment the `ProductVersion` - preferably keep it to minor
3. Verify the upgrade/downgrade conditions are met
4. After building the installer, you cannot run it as per usual, you **must** invoke it with the following flags
    * `msiexec /i Installer_Upgrade_v1_1.msi REINSTALL=ALL REINSTALLMODE=vomus /lv*x log.txt`
    * See [REINSTALLMODE flags](https://msdn.microsoft.com/en-us/library/windows/desktop/aa371182(v=vs.85).aspx)
    * The command line requirement for a minor upgrade is not very user-friendly. WiX recommends wrapping it with a Bootstrapper `.exe` or an `Autorun.inf`.

The [WiX Toolset docs](https://www.firegiant.com/wix/tutorial/upgrades-and-modularization/checking-for-oldies/) provides some basic steps for a minor upgrades but it doesn't dive into some finer details which may cause problems later on.

### Finer points on minor upgrades

This section is important; it is also a reason why WiX recommends major upgrades due to complexity with minor upgrades.

Minor upgrades are as if it is performing a "repair" - the installer will enter "Maintenance" mode and due to this, `FindRelatedProducts` will **not run**. This means that the upgrade conditions you have set will **not** be checked and will be false - this is because of `FindRelatedProducts` will usually check all versions in the Windows Installer `Upgrade` table and set the properties accordingly.

Consider the following scenario:

* `v1.msi` is installed
  * Has new file `foo.txt` (v1)
* `v1_1.msi` is installed (minor upgrade)
  * Updated file foo.txt (v1.1)
* `Upgrade_v1_2.msi` is installed (minor upgrade)
  * Updated file `foo.txt` (v1.2)
* `v1_1.msi` is re-installed (minor upgrade)
  * File `foo.txt` (v1.2) remains unchanged

Yeah, brain explosion. Minor upgrades will *only update and create new files* - you cannot remove files. A small summary that I wish I saw earlier or if it were in the docs:

>Maintenance mode installations are **not** intended for "installations".
>
>They are intended to allow installing and/or removing features from already installed products, for applying updates to products (such as patches/hotfixes/etc.), and for removing products (including the removal phase of major upgrades when `RemoveExistingProducts` removes "old" products).
>
>Things go weird when files are removed from your product. Windows Installer doesn't let you remove components in a minor upgrade, so using one file per component doesn't immediately solve the automation problem: Your automatically-generated minor upgrade will be missing a component, which is a [mortal component-rule sin](http://blogs.msdn.com/heaths/archive/2006/01/23/516457.aspx).

Read more here - [paying for upgrades](http://www.joyofsetup.com/2008/12/30/paying-for-upgrades/).

## Small Updates

* A small update makes changes to one or more application files that are too minor to warrant changing the product code.
* A small update is also commonly referred to as a quick fix engineering (QFE) update.
* A small update does **not** permit reorganization of the feature-component tree.
* A typical small update changes only one or two files or a registry key. Because a small update changes the information in the .msi file, the installation package code must be changed.

>If you want to ship updates as MSP's (Small Update or Minor Upgrade in Microsoft terminology) don't use auto-generated GUIDs.
