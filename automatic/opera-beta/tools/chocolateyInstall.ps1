$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/70.0.3728.8/win/Opera_beta_70.0.3728.8_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/70.0.3728.8/win/Opera_beta_70.0.3728.8_Setup_x64.exe'
  checksum       = '621536d90664401acaae5f5e38e4d80aab3d49568bae5bd5c19f6150789993c3'
  checksum64     = '68ed4921dafb245b197b7119839cc7e845b2bdc66461c1bb35346fbafa80f9d4'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '70.0.3728.8'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
