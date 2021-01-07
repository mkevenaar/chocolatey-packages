$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/74.0.3911.22/win/Opera_beta_74.0.3911.22_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/74.0.3911.22/win/Opera_beta_74.0.3911.22_Setup_x64.exe'
  checksum       = '45e0313a5c2394aefd64c81d44183c4974703cd62aba871567a52ce08754043e'
  checksum64     = 'e8909ac3f0b20b3b1b9c2c7d3505ce44e524abc182a54268958a694a55f63338'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '74.0.3911.22'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
