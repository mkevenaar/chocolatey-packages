$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/63.0.3367.0/win/Opera_Developer_63.0.3367.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/63.0.3367.0/win/Opera_Developer_63.0.3367.0_Setup_x64.exe'
  checksum       = '80527cb364a1587ca8ea11393ec8760a5bad61639b427f92ad4aba99e13d137c'
  checksum64     = '0375a35b208cb9c37a362cec8eed1c261eef17ebfca91dc1c983df3e6eca7a07'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '63.0.3367.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
