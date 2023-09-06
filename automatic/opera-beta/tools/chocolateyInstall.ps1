$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/102.0.4880.38/win/Opera_beta_102.0.4880.38_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/102.0.4880.38/win/Opera_beta_102.0.4880.38_Setup_x64.exe'
  checksum       = '68602cbd3c15eb33685951f6bc740153c11cbed04ffb7473afaf7391cb5d5371'
  checksum64     = 'a675a1fd820180773d3f5d5ee65dd2cee0949b8efcab8d4688dcaf3ad3b001bf'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '102.0.4880.38'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
