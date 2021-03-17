$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/75.0.3969.60/win/Opera_beta_75.0.3969.60_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/75.0.3969.60/win/Opera_beta_75.0.3969.60_Setup_x64.exe'
  checksum       = 'c5e712d0d5c489892bd5c7083af09fb97e288622fcd2175c732ed65e5e51ea8c'
  checksum64     = 'ff67d2b2abb0c54282be7fcb4fb1bcab7cadc28ff9e3c22a0c2ee05ce976ba0f'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '75.0.3969.60'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
