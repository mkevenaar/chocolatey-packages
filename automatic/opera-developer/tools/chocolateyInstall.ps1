$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/77.0.4028.0/win/Opera_Developer_77.0.4028.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/77.0.4028.0/win/Opera_Developer_77.0.4028.0_Setup_x64.exe'
  checksum       = 'df8725237bf67b160157a11204c2370fd1980df14bd45f729a21c4d2e5fc71be'
  checksum64     = 'f8523662f11c45e46448aeb21c05581bf98f86a24f1f9e41fed0cee12feb6426'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '77.0.4028.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
