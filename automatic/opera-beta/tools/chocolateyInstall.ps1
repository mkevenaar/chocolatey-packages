$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/90.0.4480.25/win/Opera_beta_90.0.4480.25_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/90.0.4480.25/win/Opera_beta_90.0.4480.25_Setup_x64.exe'
  checksum       = 'a22854b5125ab0e75391d0947047c5c849676e65408cadd21570d1b81e69f7d6'
  checksum64     = '7ed64c5ec4aa80e78c5c693e450c80fdb95bf578facba562f8a241323dd41494'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '90.0.4480.25'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
