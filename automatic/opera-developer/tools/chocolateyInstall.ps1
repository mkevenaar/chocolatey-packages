$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/131.0.5868.0/win/Opera_Developer_131.0.5868.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/131.0.5868.0/win/Opera_Developer_131.0.5868.0_Setup_x64.exe'
  checksum       = 'a9310931f0f93af003304b9ba00e1861e48b70b3082d066119cd9bee059a8e0b'
  checksum64     = 'e97b75e5c65ee0905e1715ee38e99cf58f3dc3d0d970d06d17fe3e48d351e714'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '131.0.5868.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
