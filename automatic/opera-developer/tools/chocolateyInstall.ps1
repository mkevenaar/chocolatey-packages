$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/62.0.3331.2/win/Opera_Developer_62.0.3331.2_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/62.0.3331.2/win/Opera_Developer_62.0.3331.2_Setup_x64.exe'
  checksum       = 'f1d4667888ce572db9dbdc4530da5128bc766e7c2d40e2790e14e5ab7ebc3f06'
  checksum64     = '2a6e62607d59db8aa3504a6ae985c85bedbca7c465e19c5045dbf40355d84dba'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '62.0.3331.2'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
