$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/99.0.4780.0/win/Opera_Developer_99.0.4780.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/99.0.4780.0/win/Opera_Developer_99.0.4780.0_Setup_x64.exe'
  checksum       = '81597cf9375c5558a755e8a1dff318d1ca9a98add8ce66a3a316e461562e460b'
  checksum64     = '56c06f1a58751e10235a2c3a5e56702387f4bf851c20e1157f6662b5c5f691f6'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '99.0.4780.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
