$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/115.0.5297.0/win/Opera_Developer_115.0.5297.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/115.0.5297.0/win/Opera_Developer_115.0.5297.0_Setup_x64.exe'
  checksum       = 'd696a9f5a4f15afede84e4c23c74460d1e25d59b47766dbfccdc5d5552ab421d'
  checksum64     = 'fcb29dd9fc4b9afdf145ba91ff89445bc4c3efceaa25222f7ee40cc36b32c0e1'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '115.0.5297.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
