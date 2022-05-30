$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/89.0.4436.0/win/Opera_Developer_89.0.4436.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/89.0.4436.0/win/Opera_Developer_89.0.4436.0_Setup_x64.exe'
  checksum       = 'eab31c69fe5751feccb96c5b62ed40e387ddb18f6b2dff5ff3f7e881368d1980'
  checksum64     = '35ab39a3c9298f91eec63ea247f242d5f78a2b8d250a60bf0dd99792093d9978'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '89.0.4436.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
