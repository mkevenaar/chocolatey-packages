$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/71.0.3756.0/win/Opera_Developer_71.0.3756.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/71.0.3756.0/win/Opera_Developer_71.0.3756.0_Setup_x64.exe'
  checksum       = '96664f82804d2c13578a5ac49075d37ad1e923f6c43ebe9b7fcd44df79cf6445'
  checksum64     = '5675cf986f340068061fc898435d13c32e7f3c77dfe5582c4d95c3c19b025d3d'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '71.0.3756.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
