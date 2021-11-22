$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/83.0.4246.0/win/Opera_Developer_83.0.4246.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/83.0.4246.0/win/Opera_Developer_83.0.4246.0_Setup_x64.exe'
  checksum       = '555d2e76693c913337df7837ae2b311b3fa5eb38ba7387b73bfb93dcab7338af'
  checksum64     = 'b10474fc95533058e252d60e0cc0257209375604c655ed3c8f35239c02cd6fc6'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '83.0.4246.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
