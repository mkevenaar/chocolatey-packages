$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/105.0.4957.0/win/Opera_Developer_105.0.4957.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/105.0.4957.0/win/Opera_Developer_105.0.4957.0_Setup_x64.exe'
  checksum       = '9ed08671db82f68ba7bfae42cb19d1dbf23b5f010e02ac7cbb3550102ff34ddd'
  checksum64     = '07f68ba0b847bdddb5d5ef8f8c35795cc888c0d3bbfd9e6540a57128aa6222cf'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '105.0.4957.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
