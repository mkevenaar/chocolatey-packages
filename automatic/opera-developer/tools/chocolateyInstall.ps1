$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/84.0.4309.0/win/Opera_Developer_84.0.4309.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/84.0.4309.0/win/Opera_Developer_84.0.4309.0_Setup_x64.exe'
  checksum       = '2fbdb4fd348bc11bb6c29ed44d7c6946b16fa2f83f5887f88d5d036ffd38edba'
  checksum64     = '4114bd3a56ed8b14952e77578113d18cb26ce964116a0fcf2b669d0a49acb92e'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '84.0.4309.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
