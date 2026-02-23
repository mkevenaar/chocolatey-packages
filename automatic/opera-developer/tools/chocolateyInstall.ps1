$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/129.0.5818.0/win/Opera_Developer_129.0.5818.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/129.0.5818.0/win/Opera_Developer_129.0.5818.0_Setup_x64.exe'
  checksum       = 'd9e6ec04ed74dcb201adcc9a7a7d916a61eccd75c22adf09b503f6160ce92929'
  checksum64     = 'f361a0376fabbf38bea49ec3e87febe77d5d1f59c0138c328f05912155fc6c2c'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '129.0.5818.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
