$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/83.0.4232.0/win/Opera_Developer_83.0.4232.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/83.0.4232.0/win/Opera_Developer_83.0.4232.0_Setup_x64.exe'
  checksum       = 'ad2309f7ad43c05e01b8e53951d017f05039dbb5349e7c1364eee0897b83feee'
  checksum64     = '73102c40ff55d6d76efd6620c13359e2a2a2d0e3d2a5f498dd6702d04cee3bee'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '83.0.4232.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
