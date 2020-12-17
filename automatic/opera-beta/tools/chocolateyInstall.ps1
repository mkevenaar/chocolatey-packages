$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/73.0.3856.283/win/Opera_beta_73.0.3856.283_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/73.0.3856.283/win/Opera_beta_73.0.3856.283_Setup_x64.exe'
  checksum       = '76a0adac48dfc66b28d2ec8c30e9e631b710c16cde1afa0275615bca8088ce9f'
  checksum64     = '4a9f556542452c9183b53f53db5b0ffc9362eaf39bc7edd760bc961c48e156e3'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '73.0.3856.283'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
