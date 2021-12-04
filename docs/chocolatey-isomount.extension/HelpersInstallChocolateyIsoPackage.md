# Install-ChocolateyIsoPackage

<!-- This documentation is automatically generated from https://github.com/mkevenaar/chocolatey-packages/tree/master//extensions/chocolatey-isomount.extension/extensions/Install-ChocolateyIsoPackage.ps1 using https://github.com/mkevenaar/chocolatey-packages/tree/master/GenerateDocs.ps1. Contributions are welcome at the original location(s). -->

**NOTE:** Administrative Access Required.

Installs software into "Programs and Features" based on a remote ISO file download.
Use Install-ChocolateyIsoInstallPackage when using a local or embedded file.

## Syntax


~~~powershell
Install-ChocolateyIsoPackage `
  -PackageName <String> `
  -Url <String> `
  [-FileType <String>] `
  [-SilentArgs <String[]>] `
  [-ValidExitCodes <Object>] `
  [-Checksum <String>] `
  [-ChecksumType <String>] `
  [-Options <Hashtable>] `
  [-File <String>] `
  [-File64 <String>] `
  [-UseOnlyPackageSilentArguments] `
  [-IsoCache <String>] `
  [-IgnoredArguments <Object[]>] [<CommonParameters>]
~~~

## Description

This will download an ISO file from an URL, mounts it and executes the specified native installer.
Has error handling built in.
If you are embedding the file(s) directly in the package (or do not need to download a file first),
use Install-ChocolateyIsoInstallPackage instead.

## Notes

This command will assert UAC/Admin privileges on the machine.

It will download the ISO file to the 'IsoCache' folder, if it is not already there.
This will prevent downloading the same ISO file over and over again. This function can be disabled
on a per package base by setting the 'NoCache' parameter to $true

This is a wrapper around several existing Chocolatey commandlets.

Chocolatey is copyrighted by its rightful owners. See: https://chocolatey.org

## Aliases

None

## Examples

 **EXAMPLE 1**

~~~powershell

$packageName= 'bob'
$toolsDir   = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://somewhere.com/file.iso'

$packageArgs = @{
    packageName   = $packageName
    fileType      = 'msi'
    url           = $url
    file          = 'setup.msi'
    file64        = 'x64\setup64.msi'
    silentArgs    = "/qn /norestart"
    validExitCodes= @(0, 3010, 1641)
    softwareName  = 'Bob*'
    checksum      = '12345'
    checksumType  = 'sha256'
}

Install-ChocolateyIsoPackage @packageArgs
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
 
###  -Url &lt;String&gt;
This is the url to download the resource from.

Prefer HTTPS when available. Can be HTTP, FTP, or File URIs.

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
 
###  -ValidExitCodes [&lt;Object&gt;]
Array of exit codes indicating success. Defaults to `@(0)`.

Property               | Value
---------------------- | -----
Aliases                | 
Required?              | false
Position?              | named
Default Value          | @(0)
Accept Pipeline Input? | false
 
###  -Checksum [&lt;String&gt;]
The checksum hash value of the Url resource. This allows a checksum to
be validated for files that are not local. The checksum type is covered
by ChecksumType.

**NOTE:** Checksums in packages are meant as a measure to validate the
originally intended file that was used in the creation of a package is
the same file that is received at a future date. Since this is used for
other steps in the process related to the [community repository](https://community.chocolatey.org/packages), it
ensures that the file a user receives is the same file a maintainer
and a moderator (if applicable), plus any moderation review has
intended for you to receive with this package. If you are looking at a
remote source that uses the same url for updates, you will need to
ensure the package also stays updated in line with those remote
resource updates. You should look into [automatic packaging](https://chocolatey.org/docs/automatic-packages)
to help provide that functionality.

**NOTE:** To determine checksums, you can get that from the original
site if provided. You can also use the [checksum tool available on
the [community feed](https://community.chocolatey.org/packages)](https://community.chocolatey.org/packages/checksum) (`choco install checksum`)
and use it e.g. `checksum -t sha256 -f path\to\file`. Ensure you
provide checksums for all remote resources used.

Property               | Value
---------------------- | -----
Aliases                | 
Required?              | false
Position?              | named
Default Value          | 
Accept Pipeline Input? | false
 
###  -ChecksumType [&lt;String&gt;]
The type of checkum that the file is validated with - valid
values are 'md5', 'sha1', 'sha256' or 'sha512' - defaults to 'md5'.

MD5 is not recommended as certain organizations need to use FIPS
compliant algorithms for hashing - see
https://support.microsoft.com/en-us/kb/811833 for more details.

The recommendation is to use at least SHA256.

Property               | Value
---------------------- | -----
Aliases                | 
Required?              | false
Position?              | named
Default Value          | 
Accept Pipeline Input? | false
 
###  -Options [&lt;Hashtable&gt;]
OPTIONAL - Specify custom headers. Available in 0.9.10+.

Property               | Value
---------------------- | --------------
Aliases                | 
Required?              | false
Position?              | named
Default Value          | @{Headers=@{}}
Accept Pipeline Input? | false
 
###  -File [&lt;String&gt;]
The locatation of the 32bit file inside the ISO.

Property               | Value
---------------------- | ------------
Aliases                | fileFullPath
Required?              | false
Position?              | named
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
 
###  -UseOnlyPackageSilentArguments
Do not allow choco to provide/merge additional silent arguments and only
use the ones available with the package. Available in 0.9.10+.

Property               | Value
---------------------- | ------------------------
Aliases                | useOnlyPackageSilentArgs
Required?              | false
Position?              | named
Default Value          | False
Accept Pipeline Input? | false
 
###  -IsoCache [&lt;String&gt;]
OPTIONAL - Full path to a cache location. Defaults to `$env:Temp`.

Property               | Value
---------------------- | ---------
Aliases                | 
Required?              | false
Position?              | named
Default Value          | $env:TEMP
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

 * [[Install-ChocolateyIsoInstallPackage|HelpersInstallChocolateyIsoInstallPackage]]
 * [[Get-ChocolateyWebFile|HelpersGetChocolateyWebFile]]
 * [[Install-ChocolateyInstallPackage|HelpersInstallChocolateyInstallPackage]]
 * [[Get-UninstallRegistryKey|HelpersGetUninstallRegistryKey]]
 * [[Install-ChocolateyZipPackage|HelpersInstallChocolateyZipPackage]]


[[Function Reference|HelpersReference]]

***NOTE:*** This documentation has been automatically generated from `Import-Module "$env:ChocolateyInstalls\chocolatey-isomounts\chocolatey-isomount.psm1" -Force; Get-Help Install-ChocolateyIsoPackage -Full`.

View the source for [Install-ChocolateyIsoPackage](https://github.com/mkevenaar/chocolatey-packages/tree/master//extensions/chocolatey-isomount.extension/extensions/Install-ChocolateyIsoPackage.ps1)
