$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/70.0.3728.46/win/Opera_beta_70.0.3728.46_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/70.0.3728.46/win/Opera_beta_70.0.3728.46_Setup_x64.exe'
  checksum       = '53ab1f004de9f27a7a18f54112c855959afa0d8d8ad7c82ebb0ee5dcdc568965'
  checksum64     = '741eb11e7846c2a78732e269abc9017bb66611896f9b94b176685547e82ad88f'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '70.0.3728.46'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
