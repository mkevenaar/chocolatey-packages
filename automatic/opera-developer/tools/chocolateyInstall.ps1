$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/84.0.4267.0/win/Opera_Developer_84.0.4267.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/84.0.4267.0/win/Opera_Developer_84.0.4267.0_Setup_x64.exe'
  checksum       = 'b17304b7fd25757751435352dd51bb7dadb2ebe931fbc7a2a8e88db9d27327e4'
  checksum64     = 'c6fb9cd46762a04b81eab77b6bf02c2dd834b09269afa41db1baf0fd753b0378'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '84.0.4267.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
