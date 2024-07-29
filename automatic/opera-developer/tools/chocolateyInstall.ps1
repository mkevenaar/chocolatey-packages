$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/114.0.5242.0/win/Opera_Developer_114.0.5242.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/114.0.5242.0/win/Opera_Developer_114.0.5242.0_Setup_x64.exe'
  checksum       = '8ccb1681b5c0671e4aaee9c0cc06f3bab3f347f63e931157f96797fa5e57821d'
  checksum64     = 'a17562a6a952a44ab9466fa59639010f2303def941374c5e1608267624217bd0'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '114.0.5242.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
