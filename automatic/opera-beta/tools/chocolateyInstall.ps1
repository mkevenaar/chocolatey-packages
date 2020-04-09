$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/68.0.3618.36/win/Opera_beta_68.0.3618.36_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/68.0.3618.36/win/Opera_beta_68.0.3618.36_Setup_x64.exe'
  checksum       = 'fc95206a0aec9692952f64528b2683033350ffec8a4cd828d41c56ce4e476caf'
  checksum64     = 'f1b22a3c37c62dd001a5d1a25025482ea1cc67f3277cda541d2c6504b94f2cab'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '68.0.3618.36'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
