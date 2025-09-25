$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/123.0.5666.0/win/Opera_Developer_123.0.5666.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/123.0.5666.0/win/Opera_Developer_123.0.5666.0_Setup_x64.exe'
  checksum       = '4db9068ed440cc76d359cbed3fa3fcef6da4ffaa80b79680c6f13ccbf59331ad'
  checksum64     = '0c0775954d9b76821d560a7a765b90def49bb78d8fdddaea64d54209878ae968'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '123.0.5666.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
