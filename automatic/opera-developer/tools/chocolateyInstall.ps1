$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/126.0.5748.0/win/Opera_Developer_126.0.5748.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/126.0.5748.0/win/Opera_Developer_126.0.5748.0_Setup_x64.exe'
  checksum       = '5c08f548cf2b2f47f3c2888a5fb11f4bf9fd3485a28af268c6489a613e44543e'
  checksum64     = '08382c7f6433fb8954a9b844322d1a7d29426eda125d8dc702a954ce000221d8'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '126.0.5748.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
