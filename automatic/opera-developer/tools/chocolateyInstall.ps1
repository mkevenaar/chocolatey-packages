$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/70.0.3728.0/win/Opera_Developer_70.0.3728.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/70.0.3728.0/win/Opera_Developer_70.0.3728.0_Setup_x64.exe'
  checksum       = '00bc65ef04634737d5dd9a6004259c06114b17026ad8e1abab991296b074f2d2'
  checksum64     = '8c0d4ca4eca71b852acab599f142d72edd66174ba780b67223c947c86900a4d6'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '70.0.3728.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
