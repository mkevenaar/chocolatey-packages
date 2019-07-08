$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/64.0.3372.0/win/Opera_Developer_64.0.3372.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/64.0.3372.0/win/Opera_Developer_64.0.3372.0_Setup_x64.exe'
  checksum       = '5c01f3bf9eaacb3724501b3df33b1c9a57662436364fe22f1c9d6779b2581832'
  checksum64     = '3b7b75c33e43ecae11c50aef7347ab20d8ee5cd4c9c4ff2982286cb12a7118ef'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '64.0.3372.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
