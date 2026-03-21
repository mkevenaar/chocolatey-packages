function Install-VeeamIsoPatchIfNeeded {
<#
.SYNOPSIS
  Installs a Veeam patch from an ISO when a matching entry exists in a settings XML file.

.DESCRIPTION
  Parses a Veeam setup settings XML (such as VeeamPortalSetupSettings.xml or VbrConsoleSettings.xml)
  to locate patch/update entries. If a patch is defined for the specified product (or globally), the
  patch is installed from the ISO: when the ISO path already exists it uses Install-ChocolateyIsoInstallPackage;
  when it does not, it assumes the value is a URL and uses Install-ChocolateyIsoPackage to download and install.

.PARAMETER PackageName
  Chocolatey package name used for logging and command context.

.PARAMETER IsoFile
  Full path to the ISO that contains the patch payload.

.PARAMETER SettingsFile
  Path to the extracted settings XML file to inspect for patch/update information.

.PARAMETER SilentArgs
  Arguments passed to the installer. Applied to MSI/MSP/EXE installers as appropriate.

.PARAMETER ValidExitCodes
  Array of exit codes indicating success. Defaults to @(0).

.PARAMETER Destination
  Directory used as ISO cache when downloading (Install-ChocolateyIsoPackage).

.PARAMETER ProductName
  Product node name in the settings XML to evaluate for a patch.

.EXAMPLE
  >
  Install-VeeamIsoPatchIfNeeded `
    -PackageName 'veeam-service-provider-console-iso' `
    -IsoFile 'C:\Temp\VSPC.iso' `
    -SettingsFile 'C:\Temp\VeeamPortalSetupSettings.xml' `
    -ProductName 'Server' `
    -SilentArgs '/qn /norestart' `
    -ValidExitCodes @(0, 3010) `
    -Destination "$env:TEMP\VSPC"

.LINK
  https://mkevenaar.github.io/chocolatey-packages/veeam.extension/HelpersInstallVeeamIsoPatchIfNeeded.html
#>
  [CmdletBinding(HelpUri='https://mkevenaar.github.io/chocolatey-packages/veeam.extension/HelpersInstallVeeamIsoPatchIfNeeded.html')]
  param(
    [parameter(Mandatory=$true)][string] $PackageName,
    [parameter(Mandatory=$true)][string] $IsoFile,
    [parameter(Mandatory=$true)][string] $SettingsFile,
    [parameter(Mandatory=$false)][string[]] $SilentArgs = '',
    [parameter(Mandatory=$false)] $ValidExitCodes = @(0),
    [parameter(Mandatory=$true)][string] $Destination,
    [parameter(Mandatory=$true)][string] $ProductName,
    [parameter(ValueFromRemainingArguments = $true)][Object[]] $IgnoredArguments
  )

  Write-FunctionCallLogMessage -Invocation $MyInvocation -Parameters $PSBoundParameters

  if (-not (Test-Path -LiteralPath $IsoFile -PathType Leaf)) {
    throw "ISO file not found at '$IsoFile'."
  }

  if (-not (Test-Path -LiteralPath $SettingsFile -PathType Leaf)) {
    throw "Settings file not found at '$SettingsFile'."
  }

  [string]$silentArgs = ($SilentArgs -join ' ').Trim()

  [xml]$settingsXml = Get-Content -LiteralPath $SettingsFile -Raw

  $patches = New-Object System.Collections.Generic.List[object]

  $productNode = $settingsXml.settings.product | Where-Object { $_.name -eq $ProductName }
  if ($productNode) {
    foreach ($patchNode in @($productNode.patch)) {
      if ($patchNode.package) {
        $patches.Add([PSCustomObject]@{
          Scope   = 'Product'
          Name    = $patchNode.displayName
          Package = $patchNode.package
        })
      }
    }
  }

  foreach ($updateNode in @($settingsXml.settings.updates.update)) {
    if ($updateNode.package) {
      $patches.Add([PSCustomObject]@{
        Scope   = 'Global'
        Name    = $updateNode.name
        Package = $updateNode.package
      })
    }
  }

  if ($patches.Count -eq 0) {
    Write-Host "No patch or update entries found for product '$ProductName' in '$SettingsFile'."
    return $false
  }

  $getVersionFromText = {
    param($text)
    if ([string]::IsNullOrWhiteSpace($text)) {
      return $null
    }

    $match = [regex]::Match($text, '\d+\.\d+\.\d+(?:\.\d+)?')
    if ($match.Success) {
      try { return [version]$match.Value } catch { return $null }
    }

    return $null
  }

  $patchCandidates = $patches | Select-Object *, @{
    Name       = 'ParsedVersion'
    Expression = { & $getVersionFromText $_.Package }
  }

  $selectedPatch = $patchCandidates | Sort-Object ParsedVersion -Descending | Select-Object -First 1
  if (-not $selectedPatch) {
    Write-Host "No suitable patch entry located for '$ProductName'."
    return $false
  }

  $patchFilePath = $selectedPatch.Package
  Write-Host "Applying $($selectedPatch.Scope.ToLowerInvariant()) patch '$patchFilePath' for product '$ProductName'."
  $fileType = [System.IO.Path]::GetExtension($patchFilePath).TrimStart('.').ToLowerInvariant()
  if ([string]::IsNullOrWhiteSpace($fileType)) {
    throw "Could not determine installer type for patch '$patchFilePath'."
  }

  if (Test-Path -LiteralPath $IsoFile -PathType Leaf) {
    Install-ChocolateyIsoInstallPackage -PackageName $PackageName `
                                        -IsoFile $IsoFile `
                                        -FileType $fileType `
                                        -SilentArgs $silentArgs `
                                        -File $patchFilePath `
                                        -ValidExitCodes $ValidExitCodes
  }
  else {
    Install-ChocolateyIsoPackage -PackageName $PackageName `
                                 -Url $IsoFile `
                                 -FileType $fileType `
                                 -SilentArgs $silentArgs `
                                 -File $patchFilePath `
                                 -ValidExitCodes $ValidExitCodes `
                                 -IsoCache $Destination
  }

  return $true
}
