$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/132.0.5883.0/win/Opera_Developer_132.0.5883.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/132.0.5883.0/win/Opera_Developer_132.0.5883.0_Setup_x64.exe'
  checksum       = '4b4136697319e749289b4040823879c6a3965bdeaf938aa37fe79a9ca9d41aee'
  checksum64     = 'fd89e70bc745bfec4bdfec89bc0d1f309d29685ce44988cb800df72d76e3edb2'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '132.0.5883.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
