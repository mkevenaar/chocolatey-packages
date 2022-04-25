$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/88.0.4401.0/win/Opera_Developer_88.0.4401.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/88.0.4401.0/win/Opera_Developer_88.0.4401.0_Setup_x64.exe'
  checksum       = '72340d64790d9f084e407c682784ce9d3595a294f1159cdd2dc3b09272bc4c0a'
  checksum64     = '6c93e33dde9fa4cd6ed3de39436efc9bea256587446f101caf6dfaf7884b1602'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '88.0.4401.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
