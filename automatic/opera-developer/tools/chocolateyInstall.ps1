$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/64.0.3407.0/win/Opera_Developer_64.0.3407.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/64.0.3407.0/win/Opera_Developer_64.0.3407.0_Setup_x64.exe'
  checksum       = 'fbf4ca9ad96d17363eddf823652f2f90146350d6aa31292a0bc10f66828cdb15'
  checksum64     = '86f93b7105bc9a2d7216f7a8ec80bc89608c33a498656bd2ea08e3dda40b4935'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '64.0.3407.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
