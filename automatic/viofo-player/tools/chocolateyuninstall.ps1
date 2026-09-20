$ErrorActionPreference = 'Stop'

$keys = @(Get-UninstallRegistryKey -SoftwareName 'VIOFO Player' | Where-Object { $_ })
if ($keys.Count -eq 0) {
  Write-Warning 'VIOFO Player is already uninstalled.'
  return
}
if ($keys.Count -gt 1) {
  throw 'Multiple VIOFO Player installations found. Uninstall the extra installations before continuing.'
}

$uninstaller = $keys[0].UninstallString.Trim('"')
if (!(Test-Path -LiteralPath $uninstaller -PathType Leaf) -or
    [IO.Path]::GetFileName($uninstaller) -ne 'maintenancetool.exe') {
  throw 'Unable to locate the VIOFO Player maintenance tool.'
}

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  file           = $uninstaller
  silentArgs     = '--default-answer --confirm-command purge'
  validExitCodes = @(0)
}

Uninstall-ChocolateyPackage @packageArgs
