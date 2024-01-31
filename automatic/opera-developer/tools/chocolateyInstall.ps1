$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/108.0.5063.0/win/Opera_Developer_108.0.5063.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/108.0.5063.0/win/Opera_Developer_108.0.5063.0_Setup_x64.exe'
  checksum       = 'd3612a2c3878c9b91303799cb4bfed530742fb296b64c04f8c0ac54a668155d5'
  checksum64     = 'b959631fd8008a2daf47c98efc50c3500242b8c1cb16c7a4b231f4ea6054d10c'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '108.0.5063.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
