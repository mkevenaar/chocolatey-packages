$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/132.0.5903.0/win/Opera_Developer_132.0.5903.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/132.0.5903.0/win/Opera_Developer_132.0.5903.0_Setup_x64.exe'
  checksum       = '839a95dc2ee199731b4628113ea4e11f9c7093351fe7bff927eaf967f2ebc72f'
  checksum64     = '273d959c6d1df2867c11af2d97d6fdde5eb3c473b60960cbec1d76c7cacf6cb2'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '132.0.5903.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
