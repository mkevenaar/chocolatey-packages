$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/86.0.4344.0/win/Opera_Developer_86.0.4344.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/86.0.4344.0/win/Opera_Developer_86.0.4344.0_Setup_x64.exe'
  checksum       = 'be85d0f9ccda3a371becaadc6f2e312555afe96e6cba5b75de8e197d2f125f69'
  checksum64     = 'e06ce096c9c14e7fadb9b51dac3a39a66c616484ca4ae10ab9777c66991e4cc6'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '86.0.4344.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
