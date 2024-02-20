$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/109.0.5083.0/win/Opera_Developer_109.0.5083.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/109.0.5083.0/win/Opera_Developer_109.0.5083.0_Setup_x64.exe'
  checksum       = '56c8ebe5219055069f4296caedd4273d0e56e422953884fb41cf4be5312fe84d'
  checksum64     = '05692b864224b155114521dff205753b3e336637e863bec93b5bd9e70bb8a64c'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '109.0.5083.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
