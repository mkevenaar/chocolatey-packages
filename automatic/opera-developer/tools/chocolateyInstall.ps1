$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/63.0.3353.0/win/Opera_Developer_63.0.3353.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/63.0.3353.0/win/Opera_Developer_63.0.3353.0_Setup_x64.exe'
  checksum       = '7432c9856f134844495fd9dfbfc784ab9e1c6668b18ffcab01c31b52de5eb014'
  checksum64     = '558320fe51f8ee2ae1fa14fbf51318c295bc8e5ac47c1f44c898ec1442e2e630'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '63.0.3353.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
