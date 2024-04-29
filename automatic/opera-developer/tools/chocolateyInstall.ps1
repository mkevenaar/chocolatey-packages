$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/111.0.5151.0/win/Opera_Developer_111.0.5151.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/111.0.5151.0/win/Opera_Developer_111.0.5151.0_Setup_x64.exe'
  checksum       = '206e92ca596a5ba7d5ac8f311c4a7fab8061b7229539c6db875bda3688f21c0b'
  checksum64     = '00e54599b351eb76926ddc64cfd14d5145c86f0724049fa6360ae3fd461a22c6'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '111.0.5151.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
