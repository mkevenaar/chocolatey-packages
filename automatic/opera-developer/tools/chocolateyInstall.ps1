$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/103.0.4920.0/win/Opera_Developer_103.0.4920.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/103.0.4920.0/win/Opera_Developer_103.0.4920.0_Setup_x64.exe'
  checksum       = '3564566c9f51cb9c100ab98c44ee34e997ec8a2a5e6f78c519a1715647c388ca'
  checksum64     = 'e2bb9a06c8024bf604a4613ebbe3565573df34b53521433fdba696c3c1c69bfb'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '103.0.4920.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
