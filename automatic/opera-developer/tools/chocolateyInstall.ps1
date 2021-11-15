$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/83.0.4239.0/win/Opera_Developer_83.0.4239.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/83.0.4239.0/win/Opera_Developer_83.0.4239.0_Setup_x64.exe'
  checksum       = '751ee93ffc53b38c89ac70e6d6942164a1ea52e9a4115917978c8f9098de955e'
  checksum64     = '64f3de2b0e4576ddfa1499afc5981d1ebd92a2412cc371975ca7c0293f8be31a'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '83.0.4239.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
