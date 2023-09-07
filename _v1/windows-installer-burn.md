---
layout: compsci-note
title: WiX Burn Engine and Bootstrapper
categories: [windows, windows-installer]
description: Some notes on WiX Burn Engine and Bootstrapper
---

## Contents

* [Bootstrapper command line switches](#bootstrapper-command-line-switches)
* [Logging](#logging)
* [Adding packages to the Bootstrapper](#adding-packages-to-the-bootstrapper)
* [Customizing the built-in Bootstrapper UI](#customizing-the-built-in-bootstrapper-ui)
* [Signing the Bootstrapper](#signing-the-bootstrapper)
* [Tips](#tips)

## Overview

From the [WiX Bundle documentation](https://wixtoolset.org/documentation/manual/v3/bundle/):

>A bundle is a collection of installation packages that are chained together in a single user experience. Bundles are often used to install prerequisites, such as the .NET Framework or Visual C++ runtime, before an application's .MSI file. Bundles also allow very large applications or suites of applications to be broken into smaller, logical installation packages while still presenting a single product to the end-user.
>
>To create a seamless setup experience across multiple installation packages, the WiX toolset provides an engine (often referred to as a bootstrapper or chainer) named Burn. The Burn engine is an executable that hosts a DLL called the "bootstrapper application". The bootstrapper application DLL is responsible for displaying UI to the end-user and directs the Burn engine when to carry out download, install, repair and uninstall actions. Most developers will not need to interact directly with the Burn engine because the WiX toolset provides a standard bootstrapper application and the language necessary to create bundles.
>
>Creating bundles with the WiX toolset is directly analogous to creating Windows Installer packages (.MSI files) using the language and standard UI extension provided by the WiX toolset.

## Bootstrapper command line switches

| Switch                    | Description                                                                                  |
|---------------------------|----------------------------------------------------------------------------------------------|
| `-q, -quiet, -s, -silent` | silent install                                                                               |
| `-passive`                | progress bar only install                                                                    |
| `-norestart`              | suppress any restarts                                                                        |
| `-forcerestart`           | restart no matter what (I don't know why this is still  around)                              |
| `-promptrestart`          | prompt if a restart is required (default)                                                    |
| `-layout`                 | create a local image of the bootstrapper (i.e. download files so  they can be burned to DVD) |
| `-l, -log`                | log to a specific file (default is controlled by bundle developer)                           |
| `-uninstall`              | uninstall                                                                                    |
| `-repair`                 | repair (or install if not installed)                                                         |
| `-package, -update`       | install (default if no `-uninstall` or `-repair`)                                            |

### Defining your own switches

```cmd
$ BootstrapperSetup.exe /i /passive MyBurnVariable1=1 MyBurnVariable2=2
```

Then in your `Bundle.wxs`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<Wix xmlns="http://schemas.microsoft.com/wix/2006/wi" xmlns:bal="http://schemas.microsoft.com/wix/BalExtension">

    <!-- Define and set default values -->
    <Variable Name="MyBurnVariable1" bal:Overridable="yes" Type="numeric" Value="0" />
    <Variable Name="MyBurnVariable2" bal:Overridable="yes" Type="numeric" Value="0" />

    <Chain>
        <!-- Using it as a condition for installing a package-->
        <MsiPackage
            Id="MyFirstMsiPackage"
            SourceFile="first.msi"
            InstallCondition="MyBurnVariable1 = 1">
        </MsiPackage>

        <!-- Passing and setting it as a Windows Installer Property -->
        <MsiPackage
            Id="MySecondMsiPackage"
            SourceFile="second.msi">
            <MsiProperty Name="MY_PROPERTY" Value="[MyBurnVariable2]" />
        </MsiPackage>
    </Chain>
```

## Logging

The bootstrapper will by default generate the logs for each `MsiPackage` you define in your bundle chain. If you use the logging switch (`-l -log`) and define the logging file name, the logs will be populated in the directory where it was invoked.

If the logging switch was not defined on the command line, the installation logs will reside in `C:\Users\%username%\AppData\Local\Temp` (this is Burn built-in variable value of `$(var.TempFolder)` and on Windows, corresponds to the environment variable `%TEMP%`). If performing multiple installs and uninstalls, the installation log files will be *overwritten*.

### Customizing logging location

Create a Burn variable and set the `MsiPackage/@LogPathVariable` attribute to this variable.

```xml
<Variable
    Name="CustomLogDestination"
    Type="string"
    Value="PathToYourCustomLogDir" />

<Chain>
    <MsiPackage
        Id="Installer"
        LogPathVariable="CustomLogDestination" />
</Chain>
```

## Adding packages to the Bootstrapper

The Bootstrapper allows both local and remote packages that need to be installed - these can be defined in any order with strict conditions.

A common method of reducing the installer size is to have the installer download any pre-requisite software. WiX supports the common .NET Framework versions to be downloaded remotely - be mindful of where the installer is installed in. If the environment has many network restrictions e.g. due to security, then it may be wise to embed the packages into the installer.

For remote packages, WiX will verify the SHA-1 hash of the downloaded file with the package in your build environment i.e. you need to have downloaded the remote package and place it in a location known to the WiX Bootstrapper project so it can calculate the hash and use it in the installation later.

```xml
<Bundle>
  <!-- Check the Registry -->
  <util:RegistrySearch
    Id="SqlReg"
    Root="HKLM"
    Key="SOFTWARE\SQL"
    Value="$(var.InstanceName)"
    Result="exists"
    Variable="SqlExists"
    Win64="yes" />

  <Chain>
      <ExePackage
        Id="Sql"
        DisplayName="SQL"
        DownloadUrl="https://somewhere/sql.exe"
        PerMachine="yes"
        Name="sql.exe"

        InstallCommand='/ACTION="Install" /FEATURES=SQL /IACCEPTSQLSERVERLICENSETERMS /INSTANCENAME="$(var.InstanceName)" /QS'
        UninstallCommand="/Action=Uninstall /INSTANCENAME=$(var.InstanceName) /FEATURES=SQL  /Q /HIDECONSOLE"
        DetectCondition="SqlExists"
        InstallCondition="NOT SqlExists">
      </ExePackage>

      <!-- MSI packages are much easier as the install/uninstall/detection are all handled -->
      <MsiPackage
        Id="SomeMSi"
        SourceFile="$(var.ProjectDir)\installer.msi"
        DownloadUrl="https://installer.msi"/>
  </Chain>
</Bundle>
```

### Rollback boundary

The Burn [RollbackBoundary](https://wixtoolset.org/documentation/manual/v3/xsd/wix/rollbackboundary.html) allows the Bootstrapper installation to rollback to only a certain point - the boundary - if any packages fail to install.

Let's consider an example:

For your bundle, you have 3 packages in it in a chain
These packages must succeed before proceeding to the next one

```xml
<Chain>
    <MsiPackage Id="FirstMsi" Vital="yes" />

    <MsiPackage Id="SecondMsi" Vital="yes" />

    <!-- Rollback boundary -->
    <RollbackBoundary />

    <MsiPackage Id="PackageFail" Vital="yes" />
</Chain>
```

So in this case, if `MsiPackage/@Id=PackageFail` installation fails - the bootstrapper will normally rollback all packages in the chain i.e. `SecondMsi` -> `FirstMsi` will be uninstalled/rolled-backed in that order.

**But** because the `RollbackBoundary` exists - it will only rollback the `MsiPackage/@Id=PackageFail`. This means that packages `FirstMsi` and `SecondMsi` will remain on the machine. Be mindful that this is leaving state on the machine and can only be removed manually!

## Customizing the built-in Bootstrapper UI

Adding a license agreement and a custom theme to the Bootstrapper UI is possible. Although this is limited, it is usually sufficient for most purposes. See [WiX Working with the standard Bootstrapper Application](https://wixtoolset.org/documentation/manual/v3/bundle/wixstdba/).

```xml
<Bundle>
    <!-- WiX built-in Bootstrapper Application -->
    <BootstrapperApplicationRef Id="WixStandardBootstrapperApplication.HyperlinkLicense">

      <!-- Include custom theme, license and logo -->
      <bal:WixStandardBootstrapperApplication
        LogoSideFile="Resources\Themes\SideImage.png"
        ThemeFile="Resources\Themes\CustomTheme.xml"
        LocalizationFile="Resources\Themes\CustomTheme.wxl"
        ShowVersion="yes"
        ShowFilesInUse="no" />

      <!-- Localization and resource files -->
      <Payload Id="thm_en" Name="1033\thm.wxl" Compressed="yes" SourceFile="Resources\1033\CustomTheme.wxl" />
      <Payload Id="thmx_en" Name="1033\thm.xml" Compressed="yes" SourceFile="Resources\1033\CustomTheme.xml" />
      <Payload Id="thmb_en" Name="1033\logo.png" Compressed="yes" SourceFile="Resources\1033\SideImage.png" />

    </BootstrapperApplicationRef>
</Bundle>
```

## Add/Remove Programs

You can have the Bootstrapper installer show in the ARP whilst your MSI Installer to be hidden! Make sure that you have configured this correctly because you **do not want to hide the Bootstrapper installer**. This allows you to not have the "same" two products in ARP and the Bootstrapper can handle removing any install pre-requisite installations.

```xml
<!-- Make the Boostrapper show up in ARP -->
<Bundle
    Name="$(var.ProductName)"
    Version="$(var.Version)"
    DisableRemove="no">

  <Chain>
    <!-- Hide the product from ARP but allow it to be removed by the bootstrapper! -->
    <MsiPackage
        Id="Installer"
        DisplayInternalUI="yes"
        Visible="no"
        Permanent="no" >
  </Chain>
</Bundle>
```

## Signing the Bootstrapper

See [WiX Insignia](http://wixtoolset.org/documentation/manual/v3/overview/insignia.html).

## Writing your own Bootstrapper application

Instead of using or modifying the existing WiX Bootstrapper application, you could create your own - before this sounds really good, it's important to raise the question "how necessary is it to create a custom UI and will it be worth the time investment?" Most cases it will be **no**.

The main motivation for the Burn Engine (framework) is to have a consistent approach on how to interact with the Windows Installer APIs - before, everyone was doing their own way of things.

WiX provides a basic standard Bootstrapper Application which runs on top of the Burn Engine - but it's quite restrictive, hence why many people may want to create their own Bootstrapper Application and customize its UI (e.g. Visual Studio installer that is build with WPF and .NET).

### Resources

* [Stackoverflow: on writing your Bootstrapper Application](https://stackoverflow.com/questions/7840380/custom-wix-burn-bootstrapper-user-interface)
* [Writing your own BA with .NET and WPF - very detailed](https://www.wrightfully.com/part-1-of-writing-your-own-net-based-installer-with-wix-overview/)
* [Another overview of writing your own BA in C#, MVVM pattern](https://bryanpjohnston.com/2012/09/28/custom-wix-managed-bootstrapper-application/)

## Tips

### Binding your MSI Installer version to the Bundle version

If you want your Bootstrapper version to match your MSI Installer. This is generally recommended as there is less confusion and upgrades are less prone to error.

```xml
<!-- A good way is to bind it to your Installer if desired -->
<Bundle
    Name="$(var.BundleName)"
    Version="!(bind.packageVersion.YourInstaller)">
</Bundle>
```

### Hidden Burn variables

These won't show up in the installer logs, best not to use this with passwords...

```xml
<Variable Name="SomeSensitiveString" Type="string" Value="SomethingSecret" Hidden="yes" />
```

### Extracting packages from your Bootstrapper

```cmd
$ dark.exe BootstrapperInstaller.exe -x [OutPutFolder]
```
