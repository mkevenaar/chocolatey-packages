$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/75.0.3939.0/win/Opera_Developer_75.0.3939.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/75.0.3939.0/win/Opera_Developer_75.0.3939.0_Setup_x64.exe'
  checksum       = '05e457de75655985d958526652806ef99a415f1ff6ed2e744f7a26ab182abef5'
  checksum64     = 'a899c5fdecd9e55d8c9dcd8d8262742c63c1b75c56cb6b9adcb444c015a5b1af'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '75.0.3939.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
