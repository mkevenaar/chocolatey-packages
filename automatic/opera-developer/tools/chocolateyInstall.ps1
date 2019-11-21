$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/66.0.3511.0/win/Opera_Developer_66.0.3511.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/66.0.3511.0/win/Opera_Developer_66.0.3511.0_Setup_x64.exe'
  checksum       = '14c982fad5d8d42e392dff12248631e05c58ff4f903b18fa87242060aefb8c80'
  checksum64     = '717b9d1377c98fe70822a5a540e3a82f242fb72afa7f35613ab39aad9eefe5f9'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '66.0.3511.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
