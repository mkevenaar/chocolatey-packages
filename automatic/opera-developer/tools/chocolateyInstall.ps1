$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/66.0.3472.0/win/Opera_Developer_66.0.3472.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/66.0.3472.0/win/Opera_Developer_66.0.3472.0_Setup_x64.exe'
  checksum       = '37719aa3d2ca33ec7d99b1de95068d52dffab646243e1108276bc6003cf6ea0e'
  checksum64     = 'b3e95a01cb5bc4568a9387f83fd9dc4f5ed6cee768235d26e63fe3ece66e987f'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '66.0.3472.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
