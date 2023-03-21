$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/98.0.4739.0/win/Opera_Developer_98.0.4739.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/98.0.4739.0/win/Opera_Developer_98.0.4739.0_Setup_x64.exe'
  checksum       = '4a23fb3a21aba81ae29c559bd5b1b9983e0da9b70310b106e8354c7697ca1602'
  checksum64     = 'f11c666d92d65bb9d6bb851a66b1f37f9d2efe2ce239d836c6d08e73659e9502'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '98.0.4739.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
