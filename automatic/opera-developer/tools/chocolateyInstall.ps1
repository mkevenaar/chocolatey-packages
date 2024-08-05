$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/114.0.5249.0/win/Opera_Developer_114.0.5249.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/114.0.5249.0/win/Opera_Developer_114.0.5249.0_Setup_x64.exe'
  checksum       = 'fe03ce853c2fa3a10f505d41a03e52182a5ad9ced58d1093f919226a485f56d9'
  checksum64     = 'f23916e0104ce30ba6c1bd8c0bb1f3bb23727e9ca5009628d2a4fc1e53f2254f'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '114.0.5249.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
