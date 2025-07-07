$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/121.0.5586.0/win/Opera_Developer_121.0.5586.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/121.0.5586.0/win/Opera_Developer_121.0.5586.0_Setup_x64.exe'
  checksum       = 'd250fa001e704a97ff41fa3180feebd01a75270904d110081a3cb4bac78509f2'
  checksum64     = '0bd69a6b2ae9b8dd287be7d9dfa126cb8e163ed9188efbc0c1fcd61cdc7f12ac'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '121.0.5586.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
