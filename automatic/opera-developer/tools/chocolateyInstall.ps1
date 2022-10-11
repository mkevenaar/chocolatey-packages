$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/93.0.4569.0/win/Opera_Developer_93.0.4569.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/93.0.4569.0/win/Opera_Developer_93.0.4569.0_Setup_x64.exe'
  checksum       = '9c88a584945b8bdfb5cba18d3ac25c2255451803afd337fca084ff81ac588117'
  checksum64     = 'ef8e35828f0d1bb1c5aff5649de85f09c50d96845685cd710f4e26bfa50b8cd9'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '93.0.4569.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
