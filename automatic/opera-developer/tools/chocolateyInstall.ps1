$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/130.0.5825.0/win/Opera_Developer_130.0.5825.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/130.0.5825.0/win/Opera_Developer_130.0.5825.0_Setup_x64.exe'
  checksum       = '5582a68d6132d90a27e0b6fe4fedc6d12b512622b7f9bc0885a4c7f74f997d4c'
  checksum64     = '07f01be1a6f6f6d1307c8d7afdbcf43e37cf79daf9bc6d52d996a6d33425a59e'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '130.0.5825.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
