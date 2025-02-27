$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/118.0.5456.0/win/Opera_Developer_118.0.5456.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/118.0.5456.0/win/Opera_Developer_118.0.5456.0_Setup_x64.exe'
  checksum       = 'c0ef5e8d18762122b6e149d65358e346bf5b71dc5e4788ae05975912499a0666'
  checksum64     = 'acea7365ae61b98b4ac62e6252f8e1b0b2de904eadda6bbd16dd87d2375566aa'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '118.0.5456.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
