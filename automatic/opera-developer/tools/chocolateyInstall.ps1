$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/122.0.5629.0/win/Opera_Developer_122.0.5629.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/122.0.5629.0/win/Opera_Developer_122.0.5629.0_Setup_x64.exe'
  checksum       = '8a28c167e0d3bd2819404851c301f6c14b27094e9c37d7e95a55d7b71077b35b'
  checksum64     = 'fdb1a3b2bb6302b31ee1446fa99ed963813f9975690146fadda7c4411134511b'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '122.0.5629.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
