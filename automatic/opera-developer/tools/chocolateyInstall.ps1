$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/102.0.4879.0/win/Opera_Developer_102.0.4879.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/102.0.4879.0/win/Opera_Developer_102.0.4879.0_Setup_x64.exe'
  checksum       = 'c6e552da6209771dc37d6b26fbffdbf85323144e26d05bbd448cf049681a1d27'
  checksum64     = '3dbe5a6d0527db75480be6509541032682bcdfa66c6d02950121cb7ad95545e5'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '102.0.4879.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
