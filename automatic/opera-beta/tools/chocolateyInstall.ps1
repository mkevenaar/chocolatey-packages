$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/78.0.4093.34/win/Opera_beta_78.0.4093.34_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/78.0.4093.34/win/Opera_beta_78.0.4093.34_Setup_x64.exe'
  checksum       = '10859c7af40cfd913a6b63926cbd41c0d160f5900d358f44d861e662dde51a0b'
  checksum64     = '2d36fe6fdc2e4088c9d732aafe4c82d92d3dc553349c39a1892bf9d0cc5113d2'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '78.0.4093.34'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
