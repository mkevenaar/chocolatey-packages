# Get-ChocolateyIsoFile

<!-- This documentation is automatically generated from https://github.com/mkevenaar/chocolatey-packages/tree/master//extensions/chocolatey-isomount.extension/extensions/Get-ChocolateyIsoFile.ps1 using https://github.com/mkevenaar/chocolatey-packages/tree/master/GenerateDocs.ps1. Contributions are welcome at the original location(s). -->

Copies a single file from an ISO to a destination on disk.

## Syntax


~~~powershell
Get-ChocolateyIsoFile `
  -IsoFile <String> `
  -FilePath <String> `
  -Destination <String> `
  [-FilePath64 <String>] `
  [-PackageName <String>] `
  [-DisableLogging] `
  [-IgnoredArguments <Object[]>] [<CommonParameters>]
~~~

## Description

Mounts the specified ISO using built-in PowerShell cmdlets, selects the
appropriate 32-bit or 64-bit file path, and copies that file to the
destination. This does not rely on 7-Zip or any other external tooling.

## Notes

This command will assert UAC/Admin privileges on the machine because it
uses Mount-DiskImage.

## Aliases

None

## Examples

 **EXAMPLE 1**

~~~powershell

$toolsDir = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
Get-ChocolateyIsoFile -IsoFile "$toolsDir\\image.iso" `
                      -FilePath 'setup.msi' `
                      -Destination $toolsDir
~~~ 


## Inputs

None

## Outputs

None

## Parameters


###  -IsoFile &lt;String&gt;
Full path to the ISO file to mount.

Property               | Value
---------------------- | -----
Aliases                | 
Required?              | true
Position?              | 1
Default Value          | 
Accept Pipeline Input? | false
 
###  -FilePath &lt;String&gt;
Relative path of the file inside the ISO to copy for 32-bit systems.

Property               | Value
---------------------- | -----
Aliases                | file
Required?              | true
Position?              | 2
Default Value          | 
Accept Pipeline Input? | false
 
###  -Destination &lt;String&gt;
Path to copy the file to. If this points to an existing directory (or
ends with a path separator), the file name from FilePath is used.

Property               | Value
---------------------- | ---------------
Aliases                | destinationPath
Required?              | true
Position?              | 3
Default Value          | 
Accept Pipeline Input? | false
 
###  -FilePath64 [&lt;String&gt;]
Relative path of the file inside the ISO to copy for 64-bit systems.
If provided on a 64-bit system, this file is used instead of FilePath.

Property               | Value
---------------------- | ------
Aliases                | file64
Required?              | false
Position?              | named
Default Value          | 
Accept Pipeline Input? | false
 
###  -PackageName [&lt;String&gt;]
OPTIONAL - Used to log the copied file path alongside other Chocolatey
package activity.

Property               | Value
---------------------- | -----
Aliases                | 
Required?              | false
Position?              | 4
Default Value          | 
Accept Pipeline Input? | false
 
###  -DisableLogging
OPTIONAL - Disables logging of the copied file.

Property               | Value
---------------------- | -----
Aliases                | 
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



[[Function Reference|HelpersReference]]

***NOTE:*** This documentation has been automatically generated from `Import-Module "$env:ChocolateyInstalls\chocolatey-isomounts\chocolatey-isomount.psm1" -Force; Get-Help Get-ChocolateyIsoFile -Full`.

View the source for [Get-ChocolateyIsoFile](https://github.com/mkevenaar/chocolatey-packages/tree/master//extensions/chocolatey-isomount.extension/extensions/Get-ChocolateyIsoFile.ps1)
