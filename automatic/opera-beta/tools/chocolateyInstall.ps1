$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/91.0.4516.6/win/Opera_beta_91.0.4516.6_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/91.0.4516.6/win/Opera_beta_91.0.4516.6_Setup_x64.exe'
  checksum       = 'd3bc431e5935cc6584c494e316f73607395884fbc3458104e4c440d6b3a0648d'
  checksum64     = '728286dde1c5d0de3c07980e2e1d79cdbd49e7190e333db96c0cf387d1af95fe'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '91.0.4516.6'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
