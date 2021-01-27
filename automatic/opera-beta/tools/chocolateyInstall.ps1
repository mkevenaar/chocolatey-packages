$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/74.0.3911.63/win/Opera_beta_74.0.3911.63_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/74.0.3911.63/win/Opera_beta_74.0.3911.63_Setup_x64.exe'
  checksum       = '5f630e8389ada0bf4cc6fe82f010897145515569d3877df15b75655d0d8677a1'
  checksum64     = '56bdd83dbbb754a15e925f51efa03583d0820ef8b74afca6449b07a630971b9e'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '74.0.3911.63'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
