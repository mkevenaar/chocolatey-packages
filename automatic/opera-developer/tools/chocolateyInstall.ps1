$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/101.0.4843.0/win/Opera_Developer_101.0.4843.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/101.0.4843.0/win/Opera_Developer_101.0.4843.0_Setup_x64.exe'
  checksum       = 'a40493129cff30b49f6cfa21b8a88cf33fe97a8afc729adb7ca06609e2138a4b'
  checksum64     = '29f2dd71a3c5ec46ae4a1f32138959a9ba9931af431d44c767c367f1080b3031'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '101.0.4843.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
