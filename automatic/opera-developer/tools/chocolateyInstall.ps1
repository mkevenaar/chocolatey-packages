$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/113.0.5215.0/win/Opera_Developer_113.0.5215.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/113.0.5215.0/win/Opera_Developer_113.0.5215.0_Setup_x64.exe'
  checksum       = 'ad67c3eeb0a4d1b6df04bddaa644e5522b458e53b09682d56425e056ca2cf8e3'
  checksum64     = '8eea95be3282da33ed27dc1f8cf19a07bb62bf6f57d452b375d8cfc0b0293baf'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '113.0.5215.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
