$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/84.0.4260.0/win/Opera_Developer_84.0.4260.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/84.0.4260.0/win/Opera_Developer_84.0.4260.0_Setup_x64.exe'
  checksum       = '5900da51bffa1d35ae43cbbe72aac8afaa6b1fa4f2b3a2d8c8d6d5cd389d7720'
  checksum64     = 'a1e7efb3917a132a69b3888af0f083185dac9760caf4ee56b9a36ed0134dde7c'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '84.0.4260.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
