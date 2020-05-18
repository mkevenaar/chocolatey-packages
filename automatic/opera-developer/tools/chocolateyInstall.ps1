$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/70.0.3693.0/win/Opera_Developer_70.0.3693.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/70.0.3693.0/win/Opera_Developer_70.0.3693.0_Setup_x64.exe'
  checksum       = '2b56bb97f55a2eebf75464c1b198341acbb4e93d0066f1c95bea8d4d3af7e636'
  checksum64     = 'c5fe965bfd0a27ad9a28d0179ca1361e316c47ac712f66fa1e282f618eec0a55'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '70.0.3693.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
