$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/119.0.5481.0/win/Opera_Developer_119.0.5481.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/119.0.5481.0/win/Opera_Developer_119.0.5481.0_Setup_x64.exe'
  checksum       = '807ab1d98975187ca5f18e194f45f7b6b36a92c96ef6a5968dbf0440f3773c6c'
  checksum64     = '4eb93c85f830e6e1cb1bd0c6cc1550c0c3e4664c3e941a90a313fc02c9c8bb54'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '119.0.5481.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
