$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/69.0.3630.0/win/Opera_Developer_69.0.3630.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/69.0.3630.0/win/Opera_Developer_69.0.3630.0_Setup_x64.exe'
  checksum       = 'd11cbd8b8c9288a515750667c4f24856370a137f73e1d7ea2cbba1544b5c7f65'
  checksum64     = '1bab8fabccaf4952c777d3a9e699c329c400f1e203fa367bcb5b510913565b52'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '69.0.3630.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
