$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/114.0.5272.0/win/Opera_Developer_114.0.5272.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/114.0.5272.0/win/Opera_Developer_114.0.5272.0_Setup_x64.exe'
  checksum       = '743ce74eb6e0d9e6c1f8dc5fb6e0f63c49a9f638168dc5956f15a0423368e882'
  checksum64     = '501200896dd2c1950125c4d2741b71f9f2f5795ad38b90b4b80544e6a4810bed'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '114.0.5272.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
