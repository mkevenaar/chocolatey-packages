$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/84.0.4295.0/win/Opera_Developer_84.0.4295.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/84.0.4295.0/win/Opera_Developer_84.0.4295.0_Setup_x64.exe'
  checksum       = '2939f169a07a93f8bf449f21ae9f84bfcd890bf3c2bbbbdbb7ae257ab0da02e4'
  checksum64     = 'de6b7397a02e9fa4589bb7254abc0ad2a6f4dadcc6d98253746d249927d415d2'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '84.0.4295.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
