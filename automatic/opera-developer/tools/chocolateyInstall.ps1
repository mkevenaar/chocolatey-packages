$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/80.0.4170.0/win/Opera_Developer_80.0.4170.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/80.0.4170.0/win/Opera_Developer_80.0.4170.0_Setup_x64.exe'
  checksum       = '14d4bae7a39d4312594de8728e17cd119838e140736d63454ae5f1c8822ab772'
  checksum64     = 'c3defb2cd266328490609d69d39bfc9426b250d0607c08e54b851bc7d0576022'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '80.0.4170.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
