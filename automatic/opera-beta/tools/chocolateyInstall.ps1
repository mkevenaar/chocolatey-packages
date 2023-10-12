$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/104.0.4944.10/win/Opera_beta_104.0.4944.10_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/104.0.4944.10/win/Opera_beta_104.0.4944.10_Setup_x64.exe'
  checksum       = '1ccc99e3a02c7818bd7414fac2db342f28c54ad5f53b8f5985a9f5b4dbbf5ab6'
  checksum64     = '42814b2edb1a30f12ac79c073a0ecb49aaee8ca197cced9042131c19f95cd2db'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '104.0.4944.10'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
