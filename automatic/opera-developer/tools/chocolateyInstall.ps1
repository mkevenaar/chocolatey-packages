$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/69.0.3660.0/win/Opera_Developer_69.0.3660.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/69.0.3660.0/win/Opera_Developer_69.0.3660.0_Setup_x64.exe'
  checksum       = 'f010b1a8f4f4bff01d230f3034ee9511705be03e2100a9ed01faeee0cdadedb2'
  checksum64     = '64b038a99d4f7b2c5a64f07564d71c4f414170a445da2624fb23be06ace76dc1'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '69.0.3660.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
