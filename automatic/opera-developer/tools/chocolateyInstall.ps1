$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/119.0.5467.0/win/Opera_Developer_119.0.5467.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/119.0.5467.0/win/Opera_Developer_119.0.5467.0_Setup_x64.exe'
  checksum       = '4d11180172714dc4f77ddf6a4cefc19942094c0c409dd7513d05369a3769fd4f'
  checksum64     = 'd012c2cc527afd07c5f88580534bfbb0b7db63af3f778533d99d2cbdad1909a5'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '119.0.5467.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
