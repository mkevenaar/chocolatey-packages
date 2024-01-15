$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/108.0.5047.0/win/Opera_Developer_108.0.5047.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/108.0.5047.0/win/Opera_Developer_108.0.5047.0_Setup_x64.exe'
  checksum       = '5fbbbfe10bc21f60f7d5d3edc75ddecbbacb7e9eafc58e8aad174f8fc226e9e3'
  checksum64     = 'd67790a942638e1cb7ada083c47f47e0a6f12a649839a135df7dfd35d1827da2'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '108.0.5047.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
