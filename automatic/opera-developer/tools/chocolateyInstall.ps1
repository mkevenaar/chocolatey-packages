$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/114.0.5267.0/win/Opera_Developer_114.0.5267.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/114.0.5267.0/win/Opera_Developer_114.0.5267.0_Setup_x64.exe'
  checksum       = 'c1ace88c4d1bc19a6e0b3323bbcac506baf5ecc753d269cf6f00a437e18f31e4'
  checksum64     = 'b72be9a042ab41258d01dd375e962012a902d096ce3574048b3eb7a1b6533b6b'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '114.0.5267.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
