$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/82.0.4227.13/win/Opera_beta_82.0.4227.13_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/82.0.4227.13/win/Opera_beta_82.0.4227.13_Setup_x64.exe'
  checksum       = 'e690c235bf9f4b0084b38bf9ad9f510ffe1562992efca28a10c51bb1233d49ae'
  checksum64     = '5698938a3cfd84d18eeb970723c50f91cffb9c49e85f77a37ed593b4a1b2657d'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '82.0.4227.13'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
