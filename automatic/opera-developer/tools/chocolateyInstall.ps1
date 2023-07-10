$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/102.0.4857.0/win/Opera_Developer_102.0.4857.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/102.0.4857.0/win/Opera_Developer_102.0.4857.0_Setup_x64.exe'
  checksum       = '1355ccbbd512b2c84398bfe3c2dcca9011ec53925f1796692897b0b5d1dbff23'
  checksum64     = 'c07b9ec6c8669bc9c4f0e6ef00b2be05e9e2b49d9d97f9a96578ca7251c9e363'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '102.0.4857.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
