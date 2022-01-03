$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/84.0.4284.0/win/Opera_Developer_84.0.4284.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/84.0.4284.0/win/Opera_Developer_84.0.4284.0_Setup_x64.exe'
  checksum       = 'f6e50e3942cbc8f25975ee3fe9bd07e2cee1f7fcd2910c3683afa8820951bdc6'
  checksum64     = '1fcf708bb0d144b741ac2a6e6ebb9ad5c8646e7fefe4317cc3d62db9f57bf9b0'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '84.0.4284.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
