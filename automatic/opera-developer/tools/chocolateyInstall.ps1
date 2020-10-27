$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/73.0.3856.0/win/Opera_Developer_73.0.3856.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/73.0.3856.0/win/Opera_Developer_73.0.3856.0_Setup_x64.exe'
  checksum       = '54fcf5899e94dffc49abcc9d84ed85eac1d602f9052dd43d0ac1a6f91bc6fa01'
  checksum64     = '0108bc666aebf7686601827d65782c855f6c5c78a4f8f1a14b2d8c6ed151d49f'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '73.0.3856.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
