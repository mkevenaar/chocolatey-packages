$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/86.0.4360.0/win/Opera_Developer_86.0.4360.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/86.0.4360.0/win/Opera_Developer_86.0.4360.0_Setup_x64.exe'
  checksum       = 'bd6e59381516260da29b6383727ebeea817f97c65fce8df2e588996bf15a3759'
  checksum64     = '4dd6707b6cc4f86e09140cdebca8ee8b420844c0385db91f872c34bdada1a432'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '86.0.4360.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
