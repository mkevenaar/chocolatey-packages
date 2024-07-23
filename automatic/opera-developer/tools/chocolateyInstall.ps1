$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/114.0.5236.0/win/Opera_Developer_114.0.5236.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/114.0.5236.0/win/Opera_Developer_114.0.5236.0_Setup_x64.exe'
  checksum       = '4ca631ff8fa6d96a793028d8d7b2ae565cb6d79d4596b7e8b29145d307d44f4b'
  checksum64     = 'd45472ebc18a5f04b8eae7940fc87cff4ed26108982b3db854a273f3cbd2b4de'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '114.0.5236.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
