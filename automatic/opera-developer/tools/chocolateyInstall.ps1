$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/140.0.6066.0/win/Opera_Developer_140.0.6066.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/140.0.6066.0/win/Opera_Developer_140.0.6066.0_Setup_x64.exe'
  checksum       = 'edb4622bf680e607a94762e71f8c7a64f713026d2f9e575733d627cb22efa3b5'
  checksum64     = '83abe8090492ff293df75d99a32cb1e58b047f5fbe4007147233e4a2dd8d01d6'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '140.0.6066.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
