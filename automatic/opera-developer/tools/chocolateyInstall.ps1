$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/123.0.5644.0/win/Opera_Developer_123.0.5644.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/123.0.5644.0/win/Opera_Developer_123.0.5644.0_Setup_x64.exe'
  checksum       = 'db44667326f57de7a9af94d9c0bb0b008f8a5ae6e3b940445c6ee98c9f575474'
  checksum64     = '900d0c0ac0ed2fba1d3accf58728f8240cc7a290ec5c5c5ca31f67380708cc6f'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '123.0.5644.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
