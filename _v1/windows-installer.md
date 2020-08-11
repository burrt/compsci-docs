---
layout: compsci-note
title: Windows Installer Notes
categories: [windows, windows-installer]
description: Some notes on Windows Installers
sitemap: false
---

## Contents

* [Resources](#resources)
* [WiX and Windows Installers](wix-and-windows-installers)
  * [Components](#components)
  * [Custom Actions](#custom-actions)
  * [Windows Service](#windows-service)
  * [Drivers](#drivers)
  * [Signing the Installer](#signing-the-installer)
  * [WiX Heat Tool](#wix-heat)
  * [Installer Upgrades](#installer-upgrades)
  * [Burn Engine and WiX Bootstrapper](#burn-engine-and-wix-bootstrapper)
* [Tips you don't want to miss](#tips)
  * [Suggested Installer layout](#suggested-installer-layout)

## Overview

[Wikipedia](https://en.wikipedia.org/wiki/Windows_Installer) summarizes the format of the Windows Installer Package `.msi` but I'll repeat it here for completion sake.

>* A Windows Installer package is made up of one or more full **products** and is universally identified by a GUID.
A product is a single, installed, working program (or a set of programs)
>* A **package** includes the package logic and other metadata that relates to how the package executes when running.
>* A **feature** is a hierarchical group of components. It be contain any number of components and other sub-features. You can see this on the feature selection dialog that sometimes presents itself during an installation.
>* A **component** is a basic unit of a product, they are threaded as a unit and are installed atomically. These can be program files, folders, COM, registry keys and shortcuts. They are identified by a GUID and can be shared among several features.
>* A key path is a specific file, registry key or ODBC data source that the package author specifies as critical for a given component.
>   * When an msi-based program is launched, Windows Installer checks the existence of key paths. If there is a mismatch between the current system state and the value specified in the MSI package (e.g., a key file is missing), the related feature is re-installed. This process is known as self-healing or self-repair. No two components should use the same key path.

These notes will be very focused on building Windows Installers using the WiX Toolset.

## Resources

A collection of very useful links:

* [WiX Toolset](https://wixtoolset.org/) - includes VS extension, docs, built-in dialogs etc.
* [Stackoverflow: WiX Tips and Tricks](https://stackoverflow.com/questions/471424/wix-tricks-and-tips) - don't take everything as being the *correct* way
* [MS Docs: Windows Installer](https://docs.microsoft.com/en-us/windows/desktop/Msi/windows-installer-portal) - once again, be careful about recommendations
* [MS Docs: Windows Installer standard command line options](https://docs.microsoft.com/en-us/windows/desktop/Msi/standard-installer-command-line-options)
* [A Real-world example of a Windows Installer](https://helgeklein.com/blog/2014/09/real-world-example-wix-msi-application-installer/#product_en-us-wxl) - very useful but not all parts are relevant and there is room for improvements
* [InstEd](http://www.instedit.com/) - a tool for inspecting Windows Installers, another popular tool is Orca

### Must read

* WiX: A Developer's Guide to Windows Installer XML

#### Devil in the details

Once you build a more complex installer, be sure to read these:

* [Rob Mensching: Windows Installers Intro](http://robmensching.com/blog/posts/2003/10/4/windows-installer-components-introduction/) - he has a whole bunch of blogs I think are very important to read but might be non-beginner friendly
* [Rob Mensching: Component Rules 101](http://robmensching.com/blog/posts/2003/10/18/component-rules-101/) - this may be a little confusing but at least be aware of the trouble WiX actually does in the background to make your installer behave correctly
* [Bob Arnson: paying for upgrades](http://www.joyofsetup.com/2008/12/30/paying-for-upgrades/) - some additional information about major vs minor although not that clear
* [Example installer project structure and other tutorials](http://weblogs.sqlteam.com/mladenp/archive/2010/02/11/WiX-3-Tutorial-SolutionProject-structure-and-Dev-resources.aspx)
* [Someone having a rant about issues of Minor Upgrades](https://wix.ronifuchs.com/tag/minor-upgrade/) - I agree with this person here, mixing upgrades is dangerous
* [Components and GUIDs](https://stackoverflow.com/questions/1405100/change-my-component-guid-in-wix/1422121) - caution of using hard-coded and auto-generated GUIDs
* [MS docs - Recommended InstallExecuteSequence](https://docs.microsoft.com/en-us/windows/desktop/Msi/suggested-installexecutesequence)

### Open source

* [WiX Toolset v3](https://github.com/wixtoolset/wix3/tree/master)
* [Community MSI Extensions](https://github.com/dblock/msiext) - no longer maintained but useful to see how extensions/UI dialogs are written
* [Classic WiX Burn theme](https://github.com/frederiksen/Classic-WiX-Burn-Theme) - interesting example of a custom Burn UI theme
* [Git Extensions](https://github.com/gitextensions/gitextensions/tree/master/Setup) - a fairly robust example

## WiX and Windows Installers

The WiX Toolset can be used to create Windows Installers and is well documented. It offers many built-in dialogs, actions and is excellent for basic installations.

Despite shift in the industry to move away from Windows Installers, it is still widely used (particularly in Enterprise) and well supported by Windows.

### WiX Gotchas

* In Visual Studio, it doesn't support the `AnyCPU` build configuration
  * This is due to the Registry x86/x64 locations
* WiX v3 is maintained and stable, v4 is *still* under development and is not documented
* WiX v3 does **not** support .NET Core

### Components

This is the smallest atomic unit of a Windows Installer. Be sure to read [Devil in the details](#devil-in-the-details).

Tips:

* You can let WiX auto-generate the identifiers `Component/@Id="*"`
  * The GUID is generated based on the installation directory and filename of the `File/@KeyPath` for a component
  * The GUID will stay consistent from build-build provided the directory and filename of the `KeyPath` do **not** change
* Do **not** change component GUIDs if the absolute path to your resource does **not** change - else it will conflict with the component rules

### Variables, properties, localization

There are a few key difference you need to be aware of, this [Stackoverflow](https://stackoverflow.com/questions/6827931/is-it-possible-to-pass-variable-to-wix-localization-file) post best explains it:

>There are different layers of variables in WiX:
>
>* Candle's pre-processor variables
>* Light's WixVariables/localization variables/binder variables
>* MSI's properties
>
>Each have different syntax and are evaluated at different times:
>
>Candle's preprocessor variables "`$(var.VariableName)`" are evaluated when candle runs, and can be set from candle's commandline and from "" statements. Build-time environment properties as well as custom variables can also be accessed similarly (changing the "`var.`" prefix with other values).
>Light's variables accessible from the command-line are the `WixVariables`, and accessing them is via the "`!(wix.>VariableName)`" syntax. To access your variable from your commandline, you would need to change your String to: "This build was prepared on `!(wix.BuildMachine)`"
>If you instead need to have the `BuildMachine` value exist as an MSI property at installation time (which is the "`[VariableName]`" syntax) you would need to add the following to one of your `.wxs` files in a fragment that is already linked in:
>
>Now, the environment variable `COMPUTERNAME` always has held the name of my build machines in the past, and you can access that this way: `$(env.COMPUTERNAME)`. So, you can get rid of the commandline addition to light.exe and change your wxs file like this:
>
>`<WixVariable Id="BuildMachine" Value="$(env.COMPUTERNAME)"/>`

### Registry search

Remember that there are x86/x64 Registry locations and need to be specified accordingly if you want to search for a key/value.

```xml
<Property Id="RegistryKeyExists" Value="False">
    <RegistrySearch
      Id="RegistryKeyExists"
      Root="HKLM"
      Key="SOFTWARE\Somewhere"
      Name="[PropertyKeyName]"
      Type="raw"
      Win64="$(var.Win64)" />
</Property>
```

WiX supports many Registry operations - [WiX RegistrySearch Util Extension](http://wixtoolset.org/documentation/manual/v3/xsd/util/registrysearch.html) - and more example can be found [here](https://wixtoolset.org/documentation/manual/v3/bundle/bundle_define_searches.html).

### MSI Conditions

You can schedule CAs, features, components etc. depending on MSI conditions. A great resource from [InstallShield](https://community.flexera.com/t5/InstallShield-Knowledge-Base/Common-MSI-Conditions/ta-p/3854) detailing the common ones is super handy to know.

### Custom Actions

WiX supports writing Custom Actions in C# targeting the .NET Framework. You should be aware of the scheduling on the CA:

* `commit` - indicates that the custom action will run after successful completion of the installation script (at the end of the installation)
* `deferred` - for elevated privileges and for running in the deferred execute stage. If any system state is changed, apply the reverse in the rollback.
* `firstSequence`
* `immediate` - (default) with user privileges or impersonates the installing user, it has read-write access to properties. Does **not** change system state.
oncePerProcess
* `rollback` - for rolling back a (deferred) custom action
* `secondSequence` - indicates that a custom action should be run a second time if it was previously run in an earlier sequence

#### Example C# Custom Action

```cs
// CustomActions.cs
namespace CustomActions
{
    public static class CustomActions
    {
        [CustomAction]
        public static ActionResult SomeCustomAction(Session session)
        {
            session.Log("Begin SomeCustomAction");                  // This will show in the MSI logs
            var foo = session["SOME_PROPERTY_IN_YOUR_WIX_PROJECT"]; // Inject the MSI property to the CA
            return ActionResult.Success;                            // Return a suitable result
        }

        [CustomAction]
        public static ActionResult MessageBoxTest(Session session)
        {
            // If "Cancel" was clicked, it will interrupt the installer (prematurely)
            session.Message(InstallMessage.Warning | (InstallMessage)MessageButtons.OKCancel,
            new Record
            {
                FormatString = "Some text for the Message Box."
            });

            return ActionResult.Success;
        }
    }
}
```

Take note:

* If you don't return an `ActionResult`, your MSI installer will **not** be able to detect your custom action for some reason
* After building the project, it will generate a dll located in `bin\$(Configuration)\CustomActions.CA.dll`
* You can ignore the return result if you wish in the installer
* The `session.Log()` may not appear in your installer log file if your CA appears in the `InstallUISequence` or is attached to a UI button

```xml
<!-- Product.wxs -->

<!-- Reference the CA.dll of the custom actions -->
<Binary Id="CustomActionsDll" SourceFile="$(var.CustomActions.TargetDir)\CustomActions.CA.dll" />

<!-- Define your custom action -->
<CustomAction
  Id="SomeCustomAction"
  BinaryKey="CustomActionsDll"
  DllEntry="SomeCustomAction"
  Execute="immediate"
  Return="ignore" />

<!-- Schedule when your CA is run -->
<InstallExecuteSequence>
    <Custom Action="SomeCustomAction" After="InstallInitialize">
        NOT Installed AND NOT PATCH
    </Custom>
</InstallExecuteSequence>
```

You can also call the CA on a button click on your dialog, for example:

```xml
<Control Id="TestConnButton" Type="PushButton" Default="yes" Text="!(loc.SQLServerDlg_TestLabel)">
    <Publish Event="DoAction" Value="TestSqlServerConnection" Order="3">1</Publish>
</Control>
```

#### Deferred Custom Actions

Deferred CAs are different than the "default" custom actions as they are run with elevated privileges (e.g. System, for modifying ACLs). They can only be executed in the "deferred" execution stage and **must** have an equivalent rollback custom action - any state changes must be reversed.

Deferred CAs cannot access MSI properties - you need to inject the property values via the `CustomActionData` - which will still be read-only. Alternatively, you can use immediate custom actions to update MSI properties or set values in the Registry.

```xml
<!--
  You can put these in a CustomAction.wxi and include them in the Product.wxs.
-->

<!-- Declare your custom action like normal -->
<CustomAction
    Id="DeferredCustomAction"
    DllEntry="DeferredCustomAction"
    BinaryKey="CustomActions"
    Execute="deferred"
    Return="check" />

<!-- Similar to how we set "copy" properties -->
<SetProperty
    Id="DeferredCustomAction"
    Before="DeferredCustomAction"
    Value="someKey=[SOME_PROPERTY];" />
```

```cs
// Deferred custom actions
CustomActionData customActionData = session.CustomActionData;

// Immediate custom actions
// So if we were to change these into deferred, it would be a one-line change as opposed to
// changing session["SOME_PROPERTY"] -> session.CustomActionData["someKey"]
CustomActionData customActionData = new CustomActionData(session[nameof(yourCustomActionMethodName)]);
```

#### Rollback Custom Actions

Rollback CAs are special types of deferred custom actions in that they are only invoked during the "rollback" stage e.g. failed installation. You cannot rollback CAs outside of the `InstallExecute/@InstallInitialize` and `InstallExecute/@InstallFinalize` - this is a limitation of deferred custom actions.

```xml
<!-- Declare your custom action like normal -->
<CustomAction
    Id="DeferredCustomAction"
    DllEntry="DeferredCustomAction"
    BinaryKey="CustomActions"
    Execute="rollback"
    Return="check" />

<!-- Declare the rollback custom action -->
<CustomAction
    Id="RollbackDeferredCustomAction"
    DllEntry="RollbackDeferredCustomAction"
    BinaryKey="CustomActions"
    Execute="rollback"
    Return="ignore" />

<!-- And it needs to be scheduled before the execution of your CA that you wish to rollback -->
<InstallExecuteSequence>
    <Custom Action="RollbackDeferredCustomAction" After="DeferredCustomAction">1</Custom>
    <Custom Action="DeferredCustomAction" After="InstallServices">1</Custom>
</InstallExecuteSequence>
```

#### Capturing stdout from a Process

Your CA may want to execute an executable and capturing stdout could be useful in debugging or displaying feedback.

```cs
// CustomActions.cs
// Disable process window spawns and redirects the specified streams
ProcessStartInfo processStartInfo = new ProcessStartInfo()
{
    Arguments = arguments,
    FileName = fileName,
    UseShellExecute = false,
    RedirectStandardOutput = captureStdout,
};

using (var process = new Process())
{
    process.StartInfo = processStartInfo;

    process.OutputDataReceived += (sender, args) => output += args.Data;

    process.Start();
    process.BeginOutputReadLine();
    return output;
}
```

### Windows Service

WiX supports the managements of Windows Services which is really helpful, particularly with upgrades.

```xml
<Component Id="WindowsServiceExe" Guid="*">
    <File Id="WindowsServiceExeNS" Source="..\WindowsService\bin\Debug\WindowsService.exe" />

    <ServiceInstall
      Id="SomeService"
      Name="SomeService"
      Description="A Windows Service."
      Type="ownProcess"
      Start="auto"
      ErrorControl="normal"
      Interactive="no"
      Account="[SERVICEACCOUNT_USERNAME]"
      Password="[SERVICEACCOUNT_PASSWORD]"
      Vital="yes" />

    <!-- Only supported in MSI v5.0 so be careful! -->
    <ServiceControl
      Id="SomeServiceSc"
      Name="SomeService"
      Remove="uninstall"
      Start="install"
      Stop="uninstall"
      Wait="yes" />
</Component>
```

#### Service Isolation

For Windows Vista and later, service SIDs based on the service name allowed authorization of resources to a specific service instead of the build-in identity it runs under e.g. LocalService. The [MS Docs on using Service SIDs](https://docs.microsoft.com/en-us/sql/relational-databases/security/using-service-sids-to-grant-permissions-to-services-in-sql-server?view=sql-server-ver15) is important to read.

Unfortunately WiX doesn't support the restrictions of ACLs to service SIDs - the closes is the [WiX PermissionEx Util Extension](http://wixtoolset.org/documentation/manual/v3/xsd/util/permissionex.html) which can update ACLs on `File`, `Registry`, `CreateFolder` and `ServiceInstall`. Information seems scarce but something from [Stackoverflow](https://stackoverflow.com/questions/49543312/how-to-deny-folder-permission-to-users-with-wix-installer) seems to require some knowledge in [SDDL](https://msdn.microsoft.com/en-us/library/windows/desktop/aa379567%28v=vs.85%29.aspx) (shudder).

##### C# Custom Actions to modify ACLs

Much easier to modify ACLs at the expense of burying the details in the CA and a direct coupling that is easy to forget.

```cs
// Creating a SID like normally on the commandline
using (var process = new Process())
{
    process.StartInfo.WorkingDirectory = workingDir;
    process.StartInfo.FileName = "sc.exe";
    process.StartInfo.Arguments = "sidtype someServiceName unrestricted";
    process.StartInfo.Verb = "runas";
    process.StartInfo.WindowStyle = ProcessWindowStyle.Hidden;
    process.Start();

    process.WaitForExit();
}

// Create an ACL for someUser and give it FullControl for example
var someUser = new SecurityIdentifier(SomeServiceSID);
var fullControlAccessRule = new FileSystemAccessRule(
    someUser,
    FileSystemRights.FullControl,
    AccessControlType.Allow);


// List of existing or empty access rules you want to apply on the file/directory
var accessRules = new List<FileSystemAccessRule>()
{
    fullControlAccessRule
};
// You can append or overwrite existing ACLs
var fileSecurity = file.GetAccessControl();
foreach (var accessRule in accessRules)
{
    fileSecurity.AddAccessRule(accessRule);
}

// Now set or apply the access rules
file.SetAccessControl(fileSecurity);
```

There can be issues with modifying ACLs that aren't in canonical form which will cause an exception. A possible scenario would be if the machine needs to rejoin to the domain and has "orphaned" SIDs.

### Drivers

The [WiX DIFx Extension](http://wixtoolset.org/documentation/manual/v3/xsd/difxapp/driver.html) is very useful but also pretty horrible - just like Windows Installers. I have very limited knowledge in Windows drivers but the WiX extension needs the following files:

* `driver.cat`
* `driver.inf`
* `driver.sys`

This can install kernel drivers if the `driver.inf` specifies the `DriverPackageType`:

```inf
[Version]
   Signature   = "$Windows NT$"
   Class       = Something
   ClassGuid   = {000}
   Provider    = %ProviderString%
   CatalogFile = driver.cat
   DriverPackageType = FileSystemMinifilter
```

This installs the driver to `System32` else it will install it under `System32/DriverStore`. A blog about [installing filter drivers with the DIFx extension](https://kobyk.wordpress.com/2008/10/21/installing-filter-drivers-with-difxapp-and-a-wix-v3-msi/) was one of the few resources.

#### Driver upgrades

DIFx (Windows Driver Install Framework) will automatically uninstall and upgrade its drivers. If you set `difx:Driver/@ForceInstall` to "yes", then it may do a downgrade equivalent of Windows Installers.

There doesn't seem to be too much information around this as the WiX DIFx extension is based on the DIFx documentation which is **no** longer in active development.

If in your driver.inf to copy driver.sys to `System32\Drivers` instead, specifying the `difx:Driver/@DeleteFiles="yes"` will not remove any copied files.

>Note  Starting with Windows 7, the DIFxApp configuration flag to remove installed files, together with the `DriverDeleteFiles` attribute, are ignored by the operating system. Binary files, which were copied to a system when a driver package was installed, can no longer be deleted by using DIFxApp. [MS Docs](https://technet.microsoft.com/en-us/ff549843%28v=vs.96%29)

#### Driver execution sequence

There wasn't much about when the install/uninstall of the drivers scheduling in the `InstallExecuteSequence` - [MsiProcessDrivers](https://technet.microsoft.com/en-ca/ff546212(v=vs.90)#MsiUninstallDrivers) was exposed.

Basically the `MsiProcessDrivers` custom action has the `MsiInstallDrivers` and `MsiUninstallDrivers` management inside it.

#### Using RunDll32.exe

Initially, one way was to using a CA to call the `RunDll32.exe` - this is **not recommended** but if all else fails!

```cmd
# rundll32.exe advpack.dll,LaunchINFSection inf filename[,section name][,flags][,smart reboot]

# This somehow works
cmd.exe /c RunDLL32.Exe syssetup,SetupInfObjectInstallAction DefaultInstall 128 .\driver.inf

# Apparently better methods are below
rundll32.exe setupapi.dll,InstallHinfSection DefaultInstall 128 .\driver.inf

rundll32.exe advpack.dll,LaunchINFSection .\driver.inf,,3,N
```

See also:

* [Stackoverflow: installing drivers causing reboot](https://stackoverflow.com/questions/19359696/programmatic-driver-install-via-inf-causing-reboot)
* [Stackoverflow: installing a driver inf from cmd](https://stackoverflow.com/questions/22496847/installing-a-driver-inf-file-from-command-line)
* [MS Docs: Setup API installing drivers inf](https://docs.microsoft.com/en-us/windows/desktop/api/setupapi/nf-setupapi-installhinfsectiona)


#### Driver resources

* [Stackoverflow: deploy an inf based USB driver](https://stackoverflow.com/questions/1197514/how-do-i-use-wix-to-deploy-an-inf-based-usb-driver)
* [Stackoverflow: deploy an inf based USB driver + start menu](https://stackoverflow.com/questions/45989646/how-do-i-use-wix-to-deploy-an-inf-based-usb-driver-plus-all-the-start-menu-short)
* [Stackoverflow: driver issues with installation](https://stackoverflow.com/questions/51832177/wix-silent-install-unable-to-launch-built-in-exe-wix-v3)
* [MS Docs: driver types in the INF](https://technet.microsoft.com/en-us/ff552334(v=vs.96))
* [CodeProject: driver installation with WiX DPInst](https://www.codeproject.com/Articles/44191/Drivers-Installation-With-WiX)
* [MS Docs: avoid reboot after driver installation](https://docs.microsoft.com/en-us/windows-hardware/drivers/install/avoiding-system-restarts-during-device-installations)
* [MS Forums: issues with INF installation method](https://social.msdn.microsoft.com/Forums/windows/en-US/fdb0d369-fdf4-4551-93d2-c8e1dcff9362/recommended-official-way-how-to-install-signed-wfp-callout-drivers?forum=wfp)

## Signing the Installer

```xml
<!-- WiX Installer project .wixproj -->

<Target Name="SignCabs" Condition=" '$(PfxFile)' != '' AND '$(PfxPassword)' != '' AND '$(SignToolPath)' != '' ">
    <Exec Command="&quot;$(SignToolPath)&quot; sign /debug /f $(PfxFile) /p $(PfxPassword)  /fd SHA256 /tr http://sha256timestamp.ws.symantec.com/sha256/timestamp /td SHA256 &quot;%(SignCabs.FullPath)&quot;" />
</Target>

<Target Name="SignMsi" Condition=" '$(PfxFile)' != '' AND '$(PfxPassword)' != '' AND '$(SignToolPath)' != '' ">
    <Exec Command="&quot;$(SignToolPath)&quot; sign /debug /f $(PfxFile) /p $(PfxPassword) /fd SHA256 /tr http://sha256timestamp.ws.symantec.com/sha256/timestamp /td SHA256 &quot;%(SignMsi.FullPath)&quot;" />
</Target>
```

There are a few ways of signing your WiX Bootstrapper/Installer.

* [Stackoverflow: WiX signing the Bootstrapper project](https://stackoverflow.com/questions/20381525/wix-digitally-sign-bootstrapper-project)
* [WiX signing](http://wixtoolset.org/documentation/manual/v3/overview/insignia.html)

### WiX Bootstrapper and Installer UI

This is a big topic and generally it is best to use the WiX built-in dialogs as much as possible. It is common to see installers override certain dialogs - [WiX Customizing Built-in WiXUi](https://wixtoolset.org/documentation/manual/v3/wixui/wixui_customizations.html).

#### UI Level

If you want to detect what UI level the installer is running in, you can read the [UILevel](https://docs.microsoft.com/en-us/windows/desktop/Msi/uilevel) property.

### WiX Heat

The WiX Heat tool is able to generate a `ComponentsGenerated.wxs` file which can include all your build binaries - all components will meet the component rules. This is particularly useful for programs with a large number of binaries e.g. `dotnet publish`, although with .NET 5, many files can be consolidated.

The Heat tool can be invoked in the VS Installer project `.wixproj` where you can modify the `Target`.

```xml
<!-- App.Installer.wixproj -->

<Target Name="BeforeBuild">
  <!-- Remove any old builds -->
  <Exec Command="rd /s /q $(SolutionDir)\build\" />

  <!-- Publish binaries to a build folder -->
  <Exec Command="dotnet publish ..\ -c Release -r win-x64 -o &quot;$(SolutionDir)\build\&quot;" />

  <!-- Define variables -->
  <PropertyGroup>
    <DefineConstants>BuildVersion=%(AssemblyVersion.Version);BasePath=$(SolutionDir)\build\</DefineConstants>
  </PropertyGroup>

  <!-- Use the Heat tool to harvest the build binaries and apply any filters -->
  <HeatDirectory
      OutputFile="ComponentsGenerated.wxs"
      DirectoryRefId="INSTALLFOLDER"
      ComponentGroupName="GeneratedComponents"
      SuppressCom="true"
      Directory="$(SolutionDir)\build\"
      SuppressFragments="true"
      SuppressRegistry="true"
      SuppressRootDirectory="true"
      AutoGenerateGuids="true"
      GenerateGuidsNow="true"
      ToolPath="$(WixToolPath)"
      PreprocessorVariable="var.BasePath"
      Transforms="$(SolutionDir)\ProjectInstaller\Transforms\FilterFiles.xsl" />
</Target>
```

See more of the configuration options for the [HeatDirectory](https://wixtoolset.org/documentation/manual/v3/msbuild/task_reference/heatdirectory.html), most of the default settings can be kept. The WiX documentation is excellent, be sure to read further.

#### Heat transforms

The WiX Heat tool also supports any xml transform you wish to apply to the components generated. One way use-case is to **exclude** certain files from being harvested by the Heat tool - I think there are more elegant solutions to this. A [Stackoverflow post](https://stackoverflow.com/questions/44765707/how-to-exclude-files-in-wix-toolset) details an example.

I don't recommend this way as it is similar to Custom Actions; in the sense it hides the internals of the Installer creating another layer of complexity. For example, if the transform was to exclude all `.json` files, the team **must** remember how that was achieved - burying this business logic in an xml transform is not intuitive. A paid extension from Fire Giant - [Heat Wave](https://www.firegiant.com/wix/wep-documentation/harvesting/) supports filtering in the `.wxs` file which makes it far more ideal.

#### Further reading on Heat

* [Stackoverflow: WiX Heat and ServiceInstall](https://stackoverflow.com/questions/20193681/wix-heatdirectory-serviceinstall)
* [Stackoverflow: WiX Heat and Windows Service](https://stackoverflow.com/questions/7020694/wix-3-5-install-service-from-heat-need-from-custom-action?rq=1)
* [Stackoverflow: WiX Heat customize KeyPath](https://stackoverflow.com/questions/4960884/customize-keypath-item-when-using-wix-heat-exe-to-harvest-multiple-files?rq=1)
* [WiX v3 tutorial on generating file fragments with Heat](https://weblogs.sqlteam.com/mladenp/archive/2010/02/23/WiX-3-Tutorial-Generating-filedirectory-fragments-with-Heat.exe.aspx)

### Installer Upgrades

See ....

### Burn Engine and WiX Bootstrapper

See ...

## Tips

### Access MSI properties in your localized resource files

For example, in your `en-us.xml` file:

```xml
<String Id="Message_Foo">A localized string... [Property1]</String>
```

Then set the property:

```xml
<!-- Product.wxs -->
<SetProperty Id="Property1" Value="FooBar" Sequence="execute" After="FindRelatedProducts"/>
```

### Setting pre-processor variables to MSI properties

```xml
<Property Id="Property1">$(var.Property1)</Property>
```

### Copying MSI properties

There isn't a way to "copy" variables, you need to use a custom action to effectively mimic it.

```xml
<!-- This is a cleaner way compared to defining a CA and scheduling it -->
<SetProperty Id="PropertyNew" Value="[ProductName]" Before="AppSearch" />
```

### WiX Include files

These act like C header files and is usual to avoid a very bloated `Product.wxs`.

```xml
<!-- Configuration.wxi -->
<?xml version="1.0" encoding="utf-8"?>
<Include>
    <?define ProductVersion="1.0.0"?>
    <?define UpgradeCode = "{7761351c-3716-4284-979f-1bb12a2f7f5e}" ?>
</Include>
```

### Modifying Add/Remove Programs

```xml
<!-- Remove Repair and Modify buttons -->
<Property Id="ARPNOREPAIR" Value="yes" Secure="yes" />
<Property Id="ARPNOMODIFY" Value="yes" Secure="yes" />

<!-- Add links, descriptions to the program in the Add/Remove Programs -->
<Property Id="ARPCONTACT" Value="!(loc.AppContact)"/>
<Property Id="ARPHELPLINK" Value="!(loc.AppHelpUrl)"/>
<Property Id="ARPURLINFOABOUT" Value="!(loc.AppInfoUrl)"/>
<Property Id="ARPURLUPDATEINFO" Value="!(loc.AppInfoUrl)"/>
```

### Suggested Installer layout

After contributing to some WiX Installer projects, I was surprised there isn't a "standard" approach on the layout/structure. Given they vary in complexity, laying out some ground-work early can limit the snowball and mess an Installer project can look like.

A Visual Studio representation:

#### App

* `App`
* `App.Tests`
* `App.Database`
* `App.Database.Tests`

#### App Bootstrapper

This is the WiX Burn project - see...

There are duplicate files under `/Themes` and `/1033`, this is due to the default language to use for the Bootstrapper.

* `Bundle.wxs`
* `BootstrapperVariables.wxs`
* `/Resources`
  * `/1033`
    * `AppTheme.wxl`
    * `AppTheme.xml`
    * `SideDialog.png`
* `/Themes`
  * `AppTheme.wxl`
  * `AppTheme.xml`
  * `SideDialog.png`

#### App Installer

Localizing an Installer should be ready from the start, building it in later is a *nightmare*. In-fact, localizing an installer and integrating it into the CI/CD pipeline is very painful.

The `InstallFlowSequence.wxs` file contains the `InstallExecuteSequence` - moving this into its own file isn't recommended but for complex Installers (avoid anyway...) it makes it easier to determine what and when CAs are scheduled at.

* `Product.wxs`
* `Variables.wxi`
* `InstallFlowSequence.wxs`
* `UninstallFlowSequence.wxs`
* `/Lang`
  * `/1033`
    * `App.strings.en-us.wxl`
    * `Eula.en-us.rtf`
* `/UI`
  * `CommonComponents.wxs`
  * `CustomDialog.wxs`
  * `WixUI_Basic_Override.wxs`

#### App CustomActions

* `CustomAction.cs`

#### App CustomActions Tests

Yes; unit testing custom actions does exist - [WiX Lux](https://wixtoolset.org/documentation/manual/v3/overview/lux.html). Often custom actions are the cause for installation failures and become highly complex. It is strongly recommended to limit the number of CAs and its complexity.

* `CustomActionTests.cs`
