$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/64.0.3409.0/win/Opera_Developer_64.0.3409.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/64.0.3409.0/win/Opera_Developer_64.0.3409.0_Setup_x64.exe'
  checksum       = '79f756c391c2697ec98be27f700e36eec292f9c0e519324ad5c13e26dcf0e513'
  checksum64     = 'a6554981902d1bc1f67d0a11ca07b2e3915b1b20ac8937db06bd1481bf254efe'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '64.0.3409.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
