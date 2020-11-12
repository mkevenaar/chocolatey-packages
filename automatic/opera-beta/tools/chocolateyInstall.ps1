$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/73.0.3856.156/win/Opera_beta_73.0.3856.156_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/73.0.3856.156/win/Opera_beta_73.0.3856.156_Setup_x64.exe'
  checksum       = '433f73b41ebb7d5f668fe60317b6fbc21104accd5cd87ba20266ffe03dcd4540'
  checksum64     = 'bae0d483126fddf71cfffc33239e8ad121f306395f4b08bd7b38afeef3acd3f1'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '73.0.3856.156'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
