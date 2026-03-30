$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/131.0.5853.0/win/Opera_Developer_131.0.5853.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/131.0.5853.0/win/Opera_Developer_131.0.5853.0_Setup_x64.exe'
  checksum       = '0321f1721475eb51d7cbd647fe036622df4af451e3414af739629e63f61260cf'
  checksum64     = '78b85172378e76be645f8318f6fc0c4e7293b16d5a3b6a81d497ec0e27c4d16f'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '131.0.5853.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
