$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/77.0.4046.0/win/Opera_Developer_77.0.4046.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/77.0.4046.0/win/Opera_Developer_77.0.4046.0_Setup_x64.exe'
  checksum       = '79f64b35a0265a7c68082305ac2a1d1e37dfdd7cbb880724f930c2d8f5d5ec16'
  checksum64     = '8c85da33f618231a50c55bfd710eeffbe9e1215dc256f22351efd440e4189e64'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '77.0.4046.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
