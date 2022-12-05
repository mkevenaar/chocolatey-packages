$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/95.0.4625.0/win/Opera_Developer_95.0.4625.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/95.0.4625.0/win/Opera_Developer_95.0.4625.0_Setup_x64.exe'
  checksum       = 'f12b6a4d202927c1d1ea56e980e7d4d4f8197f228a0196c28080a662eb64ae51'
  checksum64     = '11e69fda7603131d02568a9365ffbd7e37366d786fb982a0dd4c510d1dac0a8c'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '95.0.4625.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
