$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/95.0.4612.0/win/Opera_Developer_95.0.4612.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/95.0.4612.0/win/Opera_Developer_95.0.4612.0_Setup_x64.exe'
  checksum       = '3da3fb383212bacf8665e2404f8b56a8a20f9abd26aa5084c7cd7b88cbf302d4'
  checksum64     = '9931a1a73043d4a3763ed0074a1ebd1dec5ad27c85e924237ad6fd16ba398dad'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '95.0.4612.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
