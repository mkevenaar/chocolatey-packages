$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/69.0.3686.7/win/Opera_beta_69.0.3686.7_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/69.0.3686.7/win/Opera_beta_69.0.3686.7_Setup_x64.exe'
  checksum       = '3fd4162028af41453561ef9c92f4f2b8faf50c019712fefb0b13c6648f934a8c'
  checksum64     = '12391ba1319313ed955afbe5f3d9085f217eb0e7a92210d5c5a65b2ab5b33187'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '69.0.3686.7'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
