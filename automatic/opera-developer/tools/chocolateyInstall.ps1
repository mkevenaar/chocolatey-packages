$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/116.0.5335.0/win/Opera_Developer_116.0.5335.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/116.0.5335.0/win/Opera_Developer_116.0.5335.0_Setup_x64.exe'
  checksum       = '675c3508dbcccc15c0c0ed53292cf24ba1853378d04a07462665327aba56036d'
  checksum64     = '333c2840ce3c6a0f3a555c2895db7b91bc998df285fdaa9b48c8b2f2415053ad'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '116.0.5335.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
