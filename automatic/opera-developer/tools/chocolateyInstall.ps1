$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/109.0.5069.0/win/Opera_Developer_109.0.5069.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/109.0.5069.0/win/Opera_Developer_109.0.5069.0_Setup_x64.exe'
  checksum       = 'adf1667038a2e0675540f1dd0e0ea06251ae2137e4db9070bed9bd46573f240c'
  checksum64     = '25e06bad1d06ea2b6fc61fc382e493b1b1afdc0bbdd081d4c35c556d5852fd50'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '109.0.5069.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
