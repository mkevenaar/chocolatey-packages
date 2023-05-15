$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/100.0.4801.0/win/Opera_Developer_100.0.4801.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/100.0.4801.0/win/Opera_Developer_100.0.4801.0_Setup_x64.exe'
  checksum       = '5d62e0da5e19042fb240ff504f048ec5f1c85bb7886714cd673038ca10d809c6'
  checksum64     = 'c9f92e0cd9c984166a16ad469bb185b651314a22ad2a80ef8577b90de0297423'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '100.0.4801.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
