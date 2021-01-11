$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/75.0.3932.0/win/Opera_Developer_75.0.3932.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/75.0.3932.0/win/Opera_Developer_75.0.3932.0_Setup_x64.exe'
  checksum       = '762ebab797d38869d5e836e4b35dc36451f9430c3e8f56967f1396e146630259'
  checksum64     = 'a5ede184b11c4b418a98e6368449eabd7691a43433374a205977ab006c6786d0'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '75.0.3932.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
