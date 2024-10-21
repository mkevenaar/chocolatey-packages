$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/116.0.5326.0/win/Opera_Developer_116.0.5326.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/116.0.5326.0/win/Opera_Developer_116.0.5326.0_Setup_x64.exe'
  checksum       = 'e14ff658a3802dfd00ea587b0933ee7639704fa086b53e7f053bdf41a0a8d887'
  checksum64     = 'ad13c1a1a8b4386e8c99a28470e2e3e6b0ebb8164b66c373d55ecc9ee483759e'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '116.0.5326.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
