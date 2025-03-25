$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/119.0.5482.0/win/Opera_Developer_119.0.5482.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/119.0.5482.0/win/Opera_Developer_119.0.5482.0_Setup_x64.exe'
  checksum       = 'b781ea3503d7a4a2c7d60e58c115bdd8d71dd4c6ce6ce2aca5bd95b1d7178446'
  checksum64     = '1b60aa55bca380c25381da020e6912417ea826959b435a136cc2ba91958da986'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '119.0.5482.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
