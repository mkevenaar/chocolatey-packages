# Install-VeeamIsoPatchIfNeeded

<!-- This documentation is automatically generated from https://github.com/mkevenaar/chocolatey-packages/tree/master//extensions/veeam.extension/extensions/Install-VeeamIsoPatchIfNeeded.ps1 using https://github.com/mkevenaar/chocolatey-packages/tree/master/GenerateDocs.ps1. Contributions are welcome at the original location(s). -->

Installs a Veeam patch from an ISO when a matching entry exists in a settings XML file.

## Syntax


~~~powershell
Install-VeeamIsoPatchIfNeeded `
  -PackageName <String> `
  -IsoFile <String> `
  -SettingsFile <String> `
  [-SilentArgs <String[]>] `
  [-ValidExitCodes <Object>] `
  -Destination <String> `
  -ProductName <String> `
  [-IgnoredArguments <Object[]>] [<CommonParameters>]
~~~

## Description

Parses a Veeam setup settings XML (such as VeeamPortalSetupSettings.xml or VbrConsoleSettings.xml)
to locate patch/update entries. If a patch is defined for the specified product (or globally), the
patch is installed from the ISO: when the ISO path already exists it uses Install-ChocolateyIsoInstallPackage;
when it does not, it assumes the value is a URL and uses Install-ChocolateyIsoPackage to download and install.


## Aliases

None

## Examples

 **EXAMPLE 1**

~~~powershell

Install-VeeamIsoPatchIfNeeded `
  -PackageName 'veeam-service-provider-console-iso' `
  -IsoFile 'C:\Temp\VSPC.iso' `
  -SettingsFile 'C:\Temp\VeeamPortalSetupSettings.xml' `
  -ProductName 'Server' `
  -SilentArgs '/qn /norestart' `
  -ValidExitCodes @(0, 3010) `
  -Destination "$env:TEMP\VSPC"
~~~ 


## Inputs

None

## Outputs

None

## Parameters


###  -PackageName &lt;String&gt;
Chocolatey package name used for logging and command context.

Property               | Value
---------------------- | -----
Aliases                | 
Required?              | true
Position?              | 1
Default Value          | 
Accept Pipeline Input? | false
 
###  -IsoFile &lt;String&gt;
Full path to the ISO that contains the patch payload.

Property               | Value
---------------------- | -----
Aliases                | 
Required?              | true
Position?              | 2
Default Value          | 
Accept Pipeline Input? | false
 
###  -SettingsFile &lt;String&gt;
Path to the extracted settings XML file to inspect for patch/update information.

Property               | Value
---------------------- | -----
Aliases                | 
Required?              | true
Position?              | 3
Default Value          | 
Accept Pipeline Input? | false
 
###  -SilentArgs [&lt;String[]&gt;]
Arguments passed to the installer. Applied to MSI/MSP/EXE installers as appropriate.

Property               | Value
---------------------- | -----
Aliases                | 
Required?              | false
Position?              | 4
Default Value          | 
Accept Pipeline Input? | false
 
###  -ValidExitCodes [&lt;Object&gt;]
Array of exit codes indicating success. Defaults to @(0).

Property               | Value
---------------------- | -----
Aliases                | 
Required?              | false
Position?              | 5
Default Value          | @(0)
Accept Pipeline Input? | false
 
###  -Destination &lt;String&gt;
Directory used as ISO cache when downloading (Install-ChocolateyIsoPackage).

Property               | Value
---------------------- | -----
Aliases                | 
Required?              | true
Position?              | 6
Default Value          | 
Accept Pipeline Input? | false
 
###  -ProductName &lt;String&gt;
Product node name in the settings XML to evaluate for a patch.

Property               | Value
---------------------- | -----
Aliases                | 
Required?              | true
Position?              | 7
Default Value          | 
Accept Pipeline Input? | false
 
###  -IgnoredArguments [&lt;Object[]&gt;]
Property               | Value
---------------------- | -----
Aliases                | 
Required?              | false
Position?              | 8
Default Value          | 
Accept Pipeline Input? | false
 
### &lt;CommonParameters&gt;

This cmdlet supports the common parameters: -Verbose, -Debug, -ErrorAction, -ErrorVariable, -OutBuffer, and -OutVariable. For more information, see `about_CommonParameters` http://go.microsoft.com/fwlink/p/?LinkID=113216 .


## Links



[[Function Reference|HelpersReference]]

***NOTE:*** This documentation has been automatically generated from `Import-Module "$env:ChocolateyInstalls\veeams\veeam.psm1" -Force; Get-Help Install-VeeamIsoPatchIfNeeded -Full`.

View the source for [Install-VeeamIsoPatchIfNeeded](https://github.com/mkevenaar/chocolatey-packages/tree/master//extensions/veeam.extension/extensions/Install-VeeamIsoPatchIfNeeded.ps1)
