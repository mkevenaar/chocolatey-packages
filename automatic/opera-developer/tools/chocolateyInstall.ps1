$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/107.0.5012.0/win/Opera_Developer_107.0.5012.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/107.0.5012.0/win/Opera_Developer_107.0.5012.0_Setup_x64.exe'
  checksum       = '11ec56a21b2c940a985435dd6fb7b8733f50c44a64a94d4d8b4eab5edcd8a75e'
  checksum64     = '3f5c0670d30683649e0eb49d88130224cefe3d19097294090c0cb25395239504'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '107.0.5012.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
