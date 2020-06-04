$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/69.0.3686.21/win/Opera_beta_69.0.3686.21_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/69.0.3686.21/win/Opera_beta_69.0.3686.21_Setup_x64.exe'
  checksum       = 'd9de41b7c368ad7e9768984afbcfdf2a71aa092fd73e8ae5197458dbf79e5f1f'
  checksum64     = '2ef83e56cdf640a762635b6128cd115a5ba6f6fc8f2982c50d8e3de45c22ce6b'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '69.0.3686.21'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
