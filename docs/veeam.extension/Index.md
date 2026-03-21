# Veeam helpers extension

Chocolatey extension with helper functions for Veeam packages (parameter validation, silent argument building, and ISO patch installation).

**NOTE**: Requires PowerShell 3 or higher.

## Installation

Install via Chocolatey: `choco install veeam.extension`.

Add as a dependency in your package nuspec:

```xml
<dependencies>
  <dependency id="veeam.extension" version="1.0.0" />
</dependencies>
```

## Usage

Functions are available when the extension is installed as a dependency. To test interactively, import the modules:

```powershell
Import-Module $Env:ChocolateyInstall\helpers\chocolateyInstaller.psm1
Import-Module $Env:ChocolateyInstall\extensions\veeam.extension\*.psm1
```

### Validate parameters and build silent args

```powershell
$pp = Get-PackageParameters
$rules = @{
  installDir = 'Path'
  useSsl     = 'Boolean'
  retries    = 'Integer'
}

Invoke-PackageParameterValidation -Parameters $pp -Rules $rules

$silentArgs = New-Object System.Collections.Generic.List[string]
Add-SilentArgument -Buffer $silentArgs -Value ("INSTALLDIR=`"{0}`"" -f $pp.installDir)
Add-SilentArgument -Buffer $silentArgs -Value '/qn'

$msiArgs = $silentArgs -join ' '
```

### Detect and install patches from ISO settings

```powershell
Install-VeeamIsoPatchIfNeeded `
  -PackageName 'veeam-service-provider-console-iso' `
  -IsoFile 'C:\Temp\VSPC.iso' `
  -SettingsFile 'C:\Temp\VeeamPortalSetupSettings.xml' `
  -SoftwareTitle 'Veeam Management Portal Server' `
  -ProductName 'Server' `
  -SilentArgs '/qn /norestart' `
  -ValidExitCodes @(0, 3010) `
  -Destination "$env:TEMP\VSPC"
```

### Functions

- `Invoke-PackageParameterValidation`: Validates and normalizes parameters based on simple rule types (ZeroOrOne, OneOrTwo, Path, String, Integer, Boolean).
- `Add-SilentArgument`: Adds trimmed installer arguments to a `List[string]` when non-empty.
- `Install-VeeamIsoPatchIfNeeded`: Reads a Veeam settings XML to find product/global patch entries, copies the patch from the ISO, and installs it when required.
