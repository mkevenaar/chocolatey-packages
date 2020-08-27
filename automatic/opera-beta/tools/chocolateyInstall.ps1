$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/71.0.3770.81/win/Opera_beta_71.0.3770.81_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/71.0.3770.81/win/Opera_beta_71.0.3770.81_Setup_x64.exe'
  checksum       = 'cdee831a55444d7077d9ea102fc3e1df5d6cd2f4e2110bd01e1372ff41e46834'
  checksum64     = 'fa7573af2cc35b53c772c9ea35114c6af420475e484bb0957374398b90d0854c'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '71.0.3770.81'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
