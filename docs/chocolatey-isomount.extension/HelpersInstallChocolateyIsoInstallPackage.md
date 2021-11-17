# Install-ChocolateyIsoInstallPackage

<!-- This documentation is automatically generated from https://github.com/mkevenaar/chocolatey-packages/tree/master//extensions/chocolatey-isomount.extension/extensions/Install-ChocolateyIsoInstallPackage.ps1 using https://github.com/mkevenaar/chocolatey-packages/tree/master/GenerateDocs.ps1. Contributions are welcome at the original location(s). -->

**NOTE:** Administrative Access Required.

Installs software into "Programs and Features" based on a remote ISO file download.
Use Install-ChocolateyIsoPackage when the ISO needs to be downloaded first.

## Syntax


~~~powershell
Install-ChocolateyIsoInstallPackage `
  -PackageName <String> `
  -IsoFile <String> `
  [-FileType <String>] `
  [-SilentArgs <String[]>] `
  [-File <String>] `
  [-File64 <String>] `
  [-ValidExitCodes <Object>] `
  [-UseOnlyPackageSilentArguments] `
  [-IgnoredArguments <Object[]>] [<CommonParameters>]
~~~

## Description

This will mount an ISO file, and executes the specified native installer.
Has error handling built in.
If you need to download the ISO file first, use Install-ChocolateyIsoPackage instead.

## Notes

This command will assert UAC/Admin privileges on the machine.

If you are embedding ISO files into a package, ensure that you have the
rights to redistribute those files if you are sharing this package
publicly (like on the [community feed](https://community.chocolatey.org/packages)). Otherwise, please use
Install-ChocolateyIsoPackage to download those resources from their
official distribution points.

This is a wrapper around several existing Chocolatey commandlets.

Chocolatey is copyrighted by its rightful owners. See: https://chocolatey.org

## Aliases

None

## Examples

 **EXAMPLE 1**

~~~powershell

$packageName= 'bob'
$toolsDir   = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
$fileLocation = Join-Path $toolsDir 'ISO_EMBEDDED_IN_PACKAGE'

$packageArgs = @{
    packageName   = $packageName
    fileType      = 'msi'
    file          = 'setup.msi'
    file64        = 'x64\setup64.msi'
    silentArgs    = "/qn /norestart"
    validExitCodes= @(0, 3010, 1641)
    softwareName  = 'Bob*'
    isoFile       = $fileLocation
}

Install-ChocolateyIsoInstallPackage @packageArgs
~~~ 


## Inputs

None

## Outputs

None

## Parameters


###  -PackageName &lt;String&gt;
The name of the package - while this is an arbitrary value, it's
recommended that it matches the package id.

Property               | Value
---------------------- | -----
Aliases                | 
Required?              | true
Position?              | 1
Default Value          | 
Accept Pipeline Input? | false
 
###  -IsoFile &lt;String&gt;
The location of the ISO file.
If embedding in the package, you can get it to the path with
`"$(Split-Path -parent $MyInvocation.MyCommand.Definition)\\ISO_FILE"`

Property               | Value
---------------------- | -----
Aliases                | 
Required?              | true
Position?              | 2
Default Value          | 
Accept Pipeline Input? | false
 
###  -FileType [&lt;String&gt;]
This is the extension of the file. This can be 'exe', 'msi', or 'msu'.
[Licensed editions](https://chocolatey.org/compare) of Chocolatey use this to automatically determine
silent arguments. If this is not provided, Chocolatey will
automatically determine this using the downloaded file's extension.

Property               | Value
---------------------- | --------------------------
Aliases                | installerType, installType
Required?              | false
Position?              | 3
Default Value          | exe
Accept Pipeline Input? | false
 
###  -SilentArgs [&lt;String[]&gt;]
OPTIONAL - These are the parameters to pass to the native installer,
including any arguments to make the installer silent/unattended.
[Licensed editions](https://chocolatey.org/compare) of Chocolatey will automatically determine the
installer type and merge the arguments with what is provided here.

Try any of the to get the silent (unattended) installer -
`/s /S /q /Q /quiet /silent /SILENT /VERYSILENT`. With msi it is always
`/quiet`. Please pass it in still but it will be overridden by
Chocolatey to `/quiet`. If you don't pass anything it could invoke the
installer with out any arguments. That means a nonsilent installer.

Please include the `notSilent` tag in your Chocolatey package if you
are not setting up a silent/unattended package. Please note that if you
are submitting to the [community repository](https://community.chocolatey.org/packages), it is nearly a requirement
for the package to be completely unattended.

When you are using this with an MSI, it will set up the arguments as
follows:
`"C:\Full\Path\To\msiexec.exe" /i "$downloadedFileFullPath" $silentArgs`,
where `$downloadedfileFullPath` is `$url` or `$url64`, depending on what
has been decided to be used.

When you use this with MSU, it is similar to MSI above in that it finds
the right executable to run.

When you use this with executable installers, the
`$downloadedFileFullPath` will also be `$url`/`$url64` SilentArgs is
everything you call against that file, as in
`"$fileFullPath" $silentArgs"`. An example would be
`"c:\path\setup.exe" /S`, where
`$downloadedfileFullPath = "c:\path\setup.exe"` and `$silentArgs = "/S"`.

Property               | Value
---------------------- | -----
Aliases                | 
Required?              | false
Position?              | 4
Default Value          | 
Accept Pipeline Input? | false
 
###  -File [&lt;String&gt;]
The locatation of the 32bit file inside the ISO.

Property               | Value
---------------------- | ------------
Aliases                | fileFullPath
Required?              | false
Position?              | 5
Default Value          | 
Accept Pipeline Input? | false
 
###  -File64 [&lt;String&gt;]
The locatation of the 64bit file inside the ISO.

Property               | Value
---------------------- | --------------
Aliases                | fileFullPath64
Required?              | false
Position?              | named
Default Value          | 
Accept Pipeline Input? | false
 
###  -ValidExitCodes [&lt;Object&gt;]
Array of exit codes indicating success. Defaults to `@(0)`.

Property               | Value
---------------------- | -----
Aliases                | 
Required?              | false
Position?              | named
Default Value          | @(0)
Accept Pipeline Input? | false
 
###  -UseOnlyPackageSilentArguments
Do not allow choco to provide/merge additional silent arguments and
only use the ones available with the package. Available in 0.9.10+.

Property               | Value
---------------------- | ------------------------
Aliases                | useOnlyPackageSilentArgs
Required?              | false
Position?              | named
Default Value          | False
Accept Pipeline Input? | false
 
###  -IgnoredArguments [&lt;Object[]&gt;]
Allows splatting with arguments that do not apply. Do not use directly.

Property               | Value
---------------------- | -----
Aliases                | 
Required?              | false
Position?              | named
Default Value          | 
Accept Pipeline Input? | false
 
### &lt;CommonParameters&gt;

This cmdlet supports the common parameters: -Verbose, -Debug, -ErrorAction, -ErrorVariable, -OutBuffer, and -OutVariable. For more information, see `about_CommonParameters` http://go.microsoft.com/fwlink/p/?LinkID=113216 .


## Links

 * [[Install-ChocolateyPackage|HelpersInstallChocolateyPackage]]
 * [[Uninstall-ChocolateyPackage|HelpersUninstallChocolateyPackage]]
 * [[Get-UninstallRegistryKey|HelpersGetUninstallRegistryKey]]
 * [[Start-ChocolateyProcessAsAdmin|HelpersStartChocolateyProcessAsAdmin]]


[[Function Reference|HelpersReference]]

***NOTE:*** This documentation has been automatically generated from `Import-Module "$env:ChocolateyInstalls\chocolatey-isomounts\chocolatey-isomount.psm1" -Force; Get-Help Install-ChocolateyIsoInstallPackage -Full`.

View the source for [Install-ChocolateyIsoInstallPackage](https://github.com/mkevenaar/chocolatey-packages/tree/master//extensions/chocolatey-isomount.extension/extensions/Install-ChocolateyIsoInstallPackage.ps1)
