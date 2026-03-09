$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/130.0.5832.0/win/Opera_Developer_130.0.5832.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/130.0.5832.0/win/Opera_Developer_130.0.5832.0_Setup_x64.exe'
  checksum       = '3301aac1d101596ed38b20e7a5f92a8774fea02d47eb3ceff62641ed5cd3d51e'
  checksum64     = 'ce54d27e09ae8049a51008e53e35089880f67da6972a15e68d3b1ff2b1ee8034'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '130.0.5832.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
