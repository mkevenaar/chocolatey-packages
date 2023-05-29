$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/100.0.4815.0/win/Opera_Developer_100.0.4815.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/100.0.4815.0/win/Opera_Developer_100.0.4815.0_Setup_x64.exe'
  checksum       = '91863e84501c9b22db0ea25ca99d49f53fa17863f4051228495116a7aa15054c'
  checksum64     = 'd9bf1207493b8d4b6232bb1adcca4a854f6f2e0d7deb672925cc19fa9f457249'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '100.0.4815.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
