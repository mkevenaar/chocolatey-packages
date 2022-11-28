$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/95.0.4618.0/win/Opera_Developer_95.0.4618.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/95.0.4618.0/win/Opera_Developer_95.0.4618.0_Setup_x64.exe'
  checksum       = '9efa7c5d22890b350695cbac932f01d9132db1d97a4d58081f32b9c06e9e5d73'
  checksum64     = '977fa8007904b2fccd6ac51a5c538bc4fe2f93d0b208fc5d23a88908fa0e05a9'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '95.0.4618.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
