$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/66.0.3494.0/win/Opera_Developer_66.0.3494.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/66.0.3494.0/win/Opera_Developer_66.0.3494.0_Setup_x64.exe'
  checksum       = 'd1cf65d6221c61438e4c54cffdfcbf3c70798f79cc7e41254a9a97533675cf2b'
  checksum64     = 'cd0241ff8a2566796217f1962490a39b9ab03475b6d4a859356ae97294c5f14d'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '66.0.3494.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
