$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/133.0.5910.0/win/Opera_Developer_133.0.5910.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/133.0.5910.0/win/Opera_Developer_133.0.5910.0_Setup_x64.exe'
  checksum       = '3a3e01281e5d56846a2964ac863668860176f36ebf7a5f1f23a49a0a98d81858'
  checksum64     = 'bae61cbb3cfeba50c0a354503df06d30334e4b11d6accf63071bd9edcd40aae7'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '133.0.5910.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
