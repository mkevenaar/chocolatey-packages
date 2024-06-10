$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/112.0.5193.0/win/Opera_Developer_112.0.5193.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/112.0.5193.0/win/Opera_Developer_112.0.5193.0_Setup_x64.exe'
  checksum       = '251e7ca849119170f40dde631c12fed7ec0040c71ee9e0260e10c499e1557862'
  checksum64     = 'b9cb605e53a56fede3ad18d0cc540104d486160e605fca36a68d435f4d854cb5'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '112.0.5193.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
