$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/70.0.3714.0/win/Opera_Developer_70.0.3714.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/70.0.3714.0/win/Opera_Developer_70.0.3714.0_Setup_x64.exe'
  checksum       = 'e13f28eb050402230b9e9cc9ec8ee50fa35b43fae19f25f5ff8bd2461e9bc8b2'
  checksum64     = '3c10e7e4a2de663d8d87e4f12de00ffbb958f57952e81165548987d7584d34dd'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '70.0.3714.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
