$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/129.0.5812.0/win/Opera_Developer_129.0.5812.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/129.0.5812.0/win/Opera_Developer_129.0.5812.0_Setup_x64.exe'
  checksum       = '07a90cf3298b56538173cfd6d115e212a56cf5fae7d40b2f277289bc1e12ff68'
  checksum64     = 'e6d6f605afb3fdc9246a4f4bece2236ff3865a1d0cdc05d0b68101f64b05912f'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '129.0.5812.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
