$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/69.0.3673.0/win/Opera_Developer_69.0.3673.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/69.0.3673.0/win/Opera_Developer_69.0.3673.0_Setup_x64.exe'
  checksum       = '1447c9a80289d0674fa87f76e1de939b076af74105df1f31aa371f20e0cb3a78'
  checksum64     = '73aa4cf6b4fee197c23c0f20e1ad95ed3b31d7eed119aea61dd969b76d8049d8'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '69.0.3673.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
