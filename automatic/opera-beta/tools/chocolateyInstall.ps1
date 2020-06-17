$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/69.0.3686.30/win/Opera_beta_69.0.3686.30_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/69.0.3686.30/win/Opera_beta_69.0.3686.30_Setup_x64.exe'
  checksum       = '01f4155e5dcf5d32c709fdfc13d712a52df14b37b66c755a84bee7321c9ba4c8'
  checksum64     = 'd0321969a75b3e2aee2e9ba23856ee5587bda053d17999197e3aac79232e4aad'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '69.0.3686.30'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
