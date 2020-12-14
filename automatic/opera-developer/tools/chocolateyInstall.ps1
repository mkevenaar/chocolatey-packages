$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/74.0.3904.0/win/Opera_Developer_74.0.3904.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/74.0.3904.0/win/Opera_Developer_74.0.3904.0_Setup_x64.exe'
  checksum       = '9d5c1175c2abf8a1cdb507c3a25ac2daf067ec7fa138e0f1321d03f5193c9862'
  checksum64     = 'c03d6644838903f64de46bd1305435f017c0b7573ee2f1e57e5a47b09ab14737'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '74.0.3904.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
