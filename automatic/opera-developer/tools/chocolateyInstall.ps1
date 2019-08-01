$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/64.0.3396.0/win/Opera_Developer_64.0.3396.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/64.0.3396.0/win/Opera_Developer_64.0.3396.0_Setup_x64.exe'
  checksum       = '25830ef0479fb6ecfa8a2ebe02c8f509deb72b65c6a476c80836c6d92bfae02e'
  checksum64     = '14cc1efcbe0775de9b1ccb527d1c4e8c915653f83397c979f7cce80504c69dd6'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '64.0.3396.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
