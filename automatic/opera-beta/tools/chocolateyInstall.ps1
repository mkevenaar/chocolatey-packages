$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/98.0.4759.3/win/Opera_beta_98.0.4759.3_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/98.0.4759.3/win/Opera_beta_98.0.4759.3_Setup_x64.exe'
  checksum       = 'e287e774336d5ccb5e37ea894aa6aa397ab813a9f585ae7ee9da3d4849d99937'
  checksum64     = '8f66939afcfffc1ee9d04185dc67daf1ed124cc6727e98c37d30bdc8dfb20a72'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '98.0.4759.3'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
