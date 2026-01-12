$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/127.0.5776.0/win/Opera_Developer_127.0.5776.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/127.0.5776.0/win/Opera_Developer_127.0.5776.0_Setup_x64.exe'
  checksum       = '4505d1a7c8c5255b0b8d47d35f9dd6b5ebe08c477ac3f0cd030e4a6097dcb378'
  checksum64     = '56cc6bacebdf8f0cc472e90694c8939071981e9b35e93593c4b9f1d57e45948c'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '127.0.5776.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
