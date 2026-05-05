$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/132.0.5889.0/win/Opera_Developer_132.0.5889.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/132.0.5889.0/win/Opera_Developer_132.0.5889.0_Setup_x64.exe'
  checksum       = 'aee386aa194139aacdf5a918583aef0e5ccd38cb70939af04ce318a0fb51b209'
  checksum64     = '7735ffbbc16e2424e1c7356283ba3d9a7d7cab7f81c873eb150bf8a5c05d9bcd'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '132.0.5889.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
