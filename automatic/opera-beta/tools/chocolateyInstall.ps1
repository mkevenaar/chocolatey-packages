$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/72.0.3815.133/win/Opera_beta_72.0.3815.133_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/72.0.3815.133/win/Opera_beta_72.0.3815.133_Setup_x64.exe'
  checksum       = '851d662342ed3a117536c6c7c5d5b0bb46948d31bc52c7b4025e1aaf856f7db7'
  checksum64     = '30dff5f2db98cdb5b06b0acc12845649bf7912d588e0371ba5a1e304e2acf5de'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '72.0.3815.133'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
