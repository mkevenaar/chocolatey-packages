$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/104.0.4934.0/win/Opera_Developer_104.0.4934.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/104.0.4934.0/win/Opera_Developer_104.0.4934.0_Setup_x64.exe'
  checksum       = '4e3b26fa3923956a9455c34d6563dd8ee5ffb508a50d1d1485b99b1dfa8cd439'
  checksum64     = '4f23b571c5b8309452d23d8ffac43483cd7736895a908ffa082005596cb0d4ac'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '104.0.4934.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
