$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/77.0.4032.0/win/Opera_Developer_77.0.4032.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/77.0.4032.0/win/Opera_Developer_77.0.4032.0_Setup_x64.exe'
  checksum       = '5a1d49c8e4ab5db1ba54831d5e1cca1c958399277c94bd739f39e9f174c0ba83'
  checksum64     = '36e093e3935565891f3cc58df660d4db0bc3eb6d609bcb1c6c6ace2a9c4475c2'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '77.0.4032.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
