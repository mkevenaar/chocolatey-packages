$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/135.0.5960.0/win/Opera_Developer_135.0.5960.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/135.0.5960.0/win/Opera_Developer_135.0.5960.0_Setup_x64.exe'
  checksum       = 'c59fa07f2dade36f5dfcff8d68d7d8c188b3d22f49b769e912658ce1ec6f7b36'
  checksum64     = '8d0a1a78babac529367c281d07633ffd16a0d844c41c11e58c0aae87024b11cd'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '135.0.5960.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
