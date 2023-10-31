$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/106.0.4971.0/win/Opera_Developer_106.0.4971.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/106.0.4971.0/win/Opera_Developer_106.0.4971.0_Setup_x64.exe'
  checksum       = 'e6ec375cacc745325a4dcba09b26c6c312346205b30a7ade7f58ea4a63940832'
  checksum64     = 'fab5b3159b53d205da926fe950f03da7163e6abdc22b61caecc26b4b01745a0a'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '106.0.4971.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
