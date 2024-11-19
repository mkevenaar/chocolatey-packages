$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/116.0.5356.0/win/Opera_Developer_116.0.5356.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/116.0.5356.0/win/Opera_Developer_116.0.5356.0_Setup_x64.exe'
  checksum       = 'f55c86e0e20bdd0bafe32839e9c10706027faf9a5a80fed5c0c10892571996fd'
  checksum64     = 'f40ccf9405bc5129ca206032bc1d309d080bba2fce20def1259242a6027b4e9b'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '116.0.5356.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
