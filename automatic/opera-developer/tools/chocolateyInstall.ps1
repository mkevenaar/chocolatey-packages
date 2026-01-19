$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/128.0.5783.0/win/Opera_Developer_128.0.5783.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/128.0.5783.0/win/Opera_Developer_128.0.5783.0_Setup_x64.exe'
  checksum       = '0ff02dba2e8b208756f8c221e2d716af5d8be4e17aa02d78119b2a65fa52653b'
  checksum64     = '3333e4ac676d2350f1b9741b129ffd755fdcc3d98ec1fe4a294a5b268d538e29'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '128.0.5783.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
