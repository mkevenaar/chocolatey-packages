$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/96.0.4653.0/win/Opera_Developer_96.0.4653.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/96.0.4653.0/win/Opera_Developer_96.0.4653.0_Setup_x64.exe'
  checksum       = '6ab1ef816a6eb4185d18660a9f33217b3d7eec9c3de7343ac284cd3223d029a1'
  checksum64     = '16869e7cc6da012ee67558bb668530ca656f450a6a7fee2d8ddca795468a4cf2'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '96.0.4653.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
