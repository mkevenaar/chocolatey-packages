$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/89.0.4443.0/win/Opera_Developer_89.0.4443.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/89.0.4443.0/win/Opera_Developer_89.0.4443.0_Setup_x64.exe'
  checksum       = '6c17d67db42073a83afe84e2261809712e668c32c360f7747c64bafc660932b6'
  checksum64     = 'abd2372be45c402c0d3807a8c42deae73a224f82d76994e01cbde4b1d22ffdd0'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '89.0.4443.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
