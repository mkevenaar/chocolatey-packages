$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/128.0.5790.0/win/Opera_Developer_128.0.5790.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/128.0.5790.0/win/Opera_Developer_128.0.5790.0_Setup_x64.exe'
  checksum       = 'cbf0bb55d6abdd1bfbeb07631000bf7d62bea405d6c1277620b8ffb6b94e8929'
  checksum64     = '76ab1f4a944ddd6c1d959fbe0857c8a82f22c704a8a0675a09b521640f5ac06b'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '128.0.5790.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
