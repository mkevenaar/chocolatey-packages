$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/112.0.5172.0/win/Opera_Developer_112.0.5172.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/112.0.5172.0/win/Opera_Developer_112.0.5172.0_Setup_x64.exe'
  checksum       = 'ae241ad1d8f8a38dc9a28c13045021903de296960f35d573fb8ea859ec8c1dc5'
  checksum64     = 'bbb2c27ed474b2422fa12343a632060378bd871af7325002f29f63aa6f18a4b0'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '112.0.5172.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
