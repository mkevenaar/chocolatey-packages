$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/79.0.4105.0/win/Opera_Developer_79.0.4105.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/79.0.4105.0/win/Opera_Developer_79.0.4105.0_Setup_x64.exe'
  checksum       = '14478da4a6e3a8f98da88b53eae8458bf1cf9a83ad19e7e23dcfaed89044162a'
  checksum64     = '27b42cfc693bad285b0c9786f964d1afe19a8c619bb46e485d87cd046689e7d4'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '79.0.4105.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
