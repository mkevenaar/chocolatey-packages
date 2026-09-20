$ErrorActionPreference = 'Stop';

$toolsDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$url          = 'https://viofotech.com/download/player/VIOFO%20Player.exe'
$checksum     = '489c8d80b671b2ea3d0a2e79ba70ac64f33ddc606d1cd5ed2d06c241768c0e68'
$checksumType = 'sha256'

if (!(Get-OSArchitectureWidth -Compare 64) -or $env:ChocolateyForceX86 -eq 'true') {
  throw 'VIOFO Player requires 64-bit Windows.'
}

$installerDir = Join-Path $env:TEMP "$env:ChocolateyPackageName\$env:ChocolateyPackageVersion"
New-Item -ItemType Directory -Path $installerDir -Force | Out-Null

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  file           = Join-Path $installerDir 'VIOFO Player.exe'
  softwareName   = 'VIOFO Player'
  # Qt Installer Framework 4.6.1, confirmed by the installer's --help output.
  silentArgs     = '--accept-licenses --default-answer --confirm-command install'
  validExitCodes = @(0)
}

# Download and verify before uninstalling anything. AU stops at this download
# helper when calculating checksums, so an AU run cannot remove an installation.
Get-ChocolateyWebFile -PackageName $packageArgs.packageName -FileFullPath $packageArgs.file `
  -Url64bit $url -Checksum64 $checksum -ChecksumType64 $checksumType | Out-Null

$keys = @(Get-UninstallRegistryKey -SoftwareName $packageArgs.softwareName | Where-Object { $_ })
if ($keys.Count -gt 1) {
  throw 'Multiple VIOFO Player installations found. Uninstall the extra installations before continuing.'
}
if ($keys.Count -eq 1) {
  $installLocation = $keys[0].InstallLocation
  if (!$installLocation -or !(Test-Path -LiteralPath $installLocation -PathType Container)) {
    throw 'Unable to locate the existing VIOFO Player installation.'
  }

  # Qt refuses to install over an existing installation in command-line mode.
  & (Join-Path $toolsDir 'chocolateyuninstall.ps1')
  $packageArgs.silentArgs = '--root "{0}" {1}' -f $installLocation.TrimEnd('\'), $packageArgs.silentArgs
}

Install-ChocolateyInstallPackage @packageArgs
