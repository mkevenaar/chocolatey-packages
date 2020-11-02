$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/74.0.3862.0/win/Opera_Developer_74.0.3862.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/74.0.3862.0/win/Opera_Developer_74.0.3862.0_Setup_x64.exe'
  checksum       = '056fee880701e894bc528e5281d18dab6a2c5d14c20f43f4391575ab33f1fc6b'
  checksum64     = '87992cfdea0d2954607b4d5b37d39c9ea9e29e9ca21c528104d76d755b329324'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '74.0.3862.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
