$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/140.0.6058.0/win/Opera_Developer_140.0.6058.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/140.0.6058.0/win/Opera_Developer_140.0.6058.0_Setup_x64.exe'
  checksum       = '06f6fff82b72ca87cfbef30cf0f56f5425f760346a32c458c7df0d1706a298fa'
  checksum64     = '088fd7478a8f2fd3fa07ffcf3636af9a9b3e3f8ef659a3b28fd99d1c5758254d'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '140.0.6058.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
