$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/131.0.5877.0/win/Opera_Developer_131.0.5877.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/131.0.5877.0/win/Opera_Developer_131.0.5877.0_Setup_x64.exe'
  checksum       = '10b4f298b6365afda7662f24a907d8717118870379cf1fd22b4c89f1e7ffaaaa'
  checksum64     = 'ab4a58beaa65d0217625afcc8358e53f9c55da5729f377a1508ecc3a7644c9f6'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '131.0.5877.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
