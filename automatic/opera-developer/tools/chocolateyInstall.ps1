$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/98.0.4732.0/win/Opera_Developer_98.0.4732.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/98.0.4732.0/win/Opera_Developer_98.0.4732.0_Setup_x64.exe'
  checksum       = '1de3f0e280f43ff3b9fd78a3c9061d1e959ba5caf77d53d95d4d812658c88989'
  checksum64     = '53e2a72b3549407616fa83e0f2471b34b8fcbb77a36f9e0b080ba4b1baa8cb3a'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '98.0.4732.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
