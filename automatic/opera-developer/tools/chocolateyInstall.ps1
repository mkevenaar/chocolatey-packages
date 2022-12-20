$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/96.0.4640.0/win/Opera_Developer_96.0.4640.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/96.0.4640.0/win/Opera_Developer_96.0.4640.0_Setup_x64.exe'
  checksum       = '03ac85bebb4c36272d1bc94ca6845bf8c1fb7096198cfa9f16a54aa272d8698d'
  checksum64     = 'cf691aa193aceb66bbf2e53345af359e136d8ffeb05d0a8527ab1a1b3cbca996'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '96.0.4640.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
