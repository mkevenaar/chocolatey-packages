$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/74.0.3876.0/win/Opera_Developer_74.0.3876.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/74.0.3876.0/win/Opera_Developer_74.0.3876.0_Setup_x64.exe'
  checksum       = '4b39cce563a88f5c59468334ce078b3283edb77a7c56fccc43b7fbc147ce50dc'
  checksum64     = '0164ea2d612e5d2fb7b3fb8f7195d03b5ee891d3e3d7a49f53e5e275521fe2c6'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '74.0.3876.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
