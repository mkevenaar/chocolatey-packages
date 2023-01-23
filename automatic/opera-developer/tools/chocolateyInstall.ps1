$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/96.0.4674.0/win/Opera_Developer_96.0.4674.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/96.0.4674.0/win/Opera_Developer_96.0.4674.0_Setup_x64.exe'
  checksum       = '087c47cf441da8e814a559205bf49a1793fb93497b9317781679c8ab3e9f0031'
  checksum64     = '1dcdf13a2460e21219e21302b81a041452297db99224fadf3c728133fec886c1'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '96.0.4674.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
