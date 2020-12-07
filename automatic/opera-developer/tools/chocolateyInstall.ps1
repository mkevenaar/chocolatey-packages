$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/74.0.3897.0/win/Opera_Developer_74.0.3897.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/74.0.3897.0/win/Opera_Developer_74.0.3897.0_Setup_x64.exe'
  checksum       = '64ce5a3b3a3ea17035c87a2b9cc6a3ef03eb8c26717ed06ca3b5681fd3eee5fb'
  checksum64     = '553e8b770a273693d971e0517d48898f2d38c4477c3fa021a409896ea9508e56'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '74.0.3897.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
