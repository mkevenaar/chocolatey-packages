$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/79.0.4143.19/win/Opera_beta_79.0.4143.19_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/79.0.4143.19/win/Opera_beta_79.0.4143.19_Setup_x64.exe'
  checksum       = '4c41fe3c2765a806e882a50e5f791a4a93fb522cf4fd6e0ed34b300d4588d187'
  checksum64     = 'bfca8608f6fad82de1bcbba429454c15c1eda80dc897fee01ae9a4363cf08d89'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '79.0.4143.19'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
