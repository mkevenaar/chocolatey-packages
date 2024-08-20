$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/114.0.5263.0/win/Opera_Developer_114.0.5263.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/114.0.5263.0/win/Opera_Developer_114.0.5263.0_Setup_x64.exe'
  checksum       = '167426c06a8be0b8dbc410e398794a7b8f81f25f14c7fbb3325eeee9752c42f0'
  checksum64     = 'dbc364a97054b5e0f82e122664e13c9d4cbf978d24f19a844c9f256a450a228c'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '114.0.5263.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
