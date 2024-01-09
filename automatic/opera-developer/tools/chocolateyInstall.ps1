$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/107.0.5041.0/win/Opera_Developer_107.0.5041.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/107.0.5041.0/win/Opera_Developer_107.0.5041.0_Setup_x64.exe'
  checksum       = 'c1673c82fa4c004e66bb48d68eb3d3beb4e3cc2e1fa2c6c05cd8a71fdbd49eae'
  checksum64     = 'beb3da61ef0d398a2c4d8d2d0d251e4e357dedaab77a832252130dd727436b75'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '107.0.5041.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
