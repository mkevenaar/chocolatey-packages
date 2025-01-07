$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/117.0.5405.0/win/Opera_Developer_117.0.5405.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/117.0.5405.0/win/Opera_Developer_117.0.5405.0_Setup_x64.exe'
  checksum       = '92c560a6cd47e89f6d379f5663c78365f317fb7ccadede994a7fd3620fc50808'
  checksum64     = 'dbbb6c3bd60f971477af1527c0aa368ec7618363cb849810b44e52138ed224b3'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '117.0.5405.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
