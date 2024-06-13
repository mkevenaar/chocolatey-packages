$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/112.0.5196.0/win/Opera_Developer_112.0.5196.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/112.0.5196.0/win/Opera_Developer_112.0.5196.0_Setup_x64.exe'
  checksum       = '4b4bd876d1a35811b4b76a7c50fab8757d6b9890d53b22f246b9d590396b62e3'
  checksum64     = '7076a98ca2b20c2e6c4e3d6bef87ea05d33e12edb275a885ef030df42773936e'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '112.0.5196.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
