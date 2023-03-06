$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/98.0.4725.0/win/Opera_Developer_98.0.4725.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/98.0.4725.0/win/Opera_Developer_98.0.4725.0_Setup_x64.exe'
  checksum       = 'f8916b3ba3f02f6ddcfb8d852de69a41b07bf874d2574b2a7069d6a25400ae62'
  checksum64     = '2c4e32d2fa16115d3dc646397b6565f204068000abefbd518334ff40868a26db'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '98.0.4725.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
