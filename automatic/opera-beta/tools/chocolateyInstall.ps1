$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/94.0.4606.8/win/Opera_beta_94.0.4606.8_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/94.0.4606.8/win/Opera_beta_94.0.4606.8_Setup_x64.exe'
  checksum       = 'e18601f51d1914ac237f0c84fa08035896230b59030c94a731227959740aa2a3'
  checksum64     = '04bb1e81a5341fc2dded692ecd38af83e70bae74692da336480333bc711c4ee5'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '94.0.4606.8'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
