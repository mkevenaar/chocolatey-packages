$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/73.0.3841.0/win/Opera_Developer_73.0.3841.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/73.0.3841.0/win/Opera_Developer_73.0.3841.0_Setup_x64.exe'
  checksum       = 'bfd91e20aa464f0d178ec709a42206c331b0be4c08e799ed0326bf79eb11ef04'
  checksum64     = 'faa383c558007b44376f30b6cd62f51be77965ce9f56627127c50b6d1ec81eab'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '73.0.3841.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
