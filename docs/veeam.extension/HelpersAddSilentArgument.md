# Add-SilentArgument

<!--
This documentation is automatically generated from
https://github.com/mkevenaar/chocolatey-packages/tree/master/extensions/veeam.extension/extensions/Add-SilentArgument.ps1
using https://github.com/mkevenaar/chocolatey-packages/tree/master/GenerateDocs.ps1.
Contributions are welcome at the original location(s).
-->

Adds a trimmed installer argument to a buffer when it is non-empty.

## Syntax

```powershell
Add-SilentArgument `
  [-Buffer <List`1>] `
  [-Value <String>] [<CommonParameters>]
```

## Description

Ensures a valid buffer is provided, ignores null/whitespace values, trims
the input, and appends it to the supplied List[string]. Useful when building
Chocolatey silent argument lists conditionally.

## Aliases

None

## Examples

### EXAMPLE 1

```powershell
$silentArgs = New-Object System.Collections.Generic.List[string]
Add-SilentArgument -Buffer $silentArgs -Value '/qn'
Add-SilentArgument -Buffer $silentArgs -Value ("INSTALLDIR=`"{0}`"" -f $pp.installDir)
```

## Inputs

None

## Outputs

None

## Parameters

### -Buffer [&lt;List`1&gt;]

A System.Collections.Generic.List[string] to append arguments to.

| Property | Value |
| -------- | ----- |
| Aliases | |
| Required? | false |
| Position? | 1 |
| Default Value | |
| Accept Pipeline Input? | false |

### -Value [&lt;String&gt;]

The argument text to add when not null or whitespace.

| Property | Value |
| -------- | ----- |
| Aliases | |
| Required? | false |
| Position? | 2 |
| Default Value | |
| Accept Pipeline Input? | false |

### &lt;CommonParameters&gt;

This cmdlet supports the common parameters. For more information, see
[about_CommonParameters](http://go.microsoft.com/fwlink/p/?LinkID=113216).

## Links

- [https://mkevenaar.github.io/chocolatey-packages/veeam.extension/HelpersAddSilentArgument.html](https://mkevenaar.github.io/chocolatey-packages/veeam.extension/HelpersAddSilentArgument.html)

[Extension documentation](Index.html)

***NOTE:*** This documentation has been automatically generated using:

```powershell
$extensionPath = Join-Path $env:ChocolateyInstall 'extensions\veeam'
Import-Module (Join-Path $extensionPath 'veeam.psm1') -Force
Get-Help Add-SilentArgument -Full
```

View the source for
[Add-SilentArgument](https://github.com/mkevenaar/chocolatey-packages/tree/master/extensions/veeam.extension/extensions/Add-SilentArgument.ps1)
