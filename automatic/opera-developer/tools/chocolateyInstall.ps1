$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/76.0.4009.0/win/Opera_Developer_76.0.4009.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/76.0.4009.0/win/Opera_Developer_76.0.4009.0_Setup_x64.exe'
  checksum       = '877c88246928f9617209a3ba580dbcaa065cf43e48e1efe0b9c93dfef165b884'
  checksum64     = 'aa540d2a83065c4007dac909b4c19885260e2692fb6ea7c3a3d3c807f84ad6f1'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '76.0.4009.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
