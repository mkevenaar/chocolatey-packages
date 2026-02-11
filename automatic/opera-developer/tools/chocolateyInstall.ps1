$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/128.0.5806.0/win/Opera_Developer_128.0.5806.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/128.0.5806.0/win/Opera_Developer_128.0.5806.0_Setup_x64.exe'
  checksum       = '6e2815ae18a97958e614ad22423cb1d43a8f1201a52313440a3c2793850e540d'
  checksum64     = 'a4bd70d5d72dbbb0eed8d0e08359f27a1f33ef7081bcb94f01cc885b9aaf9f9c'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '128.0.5806.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
