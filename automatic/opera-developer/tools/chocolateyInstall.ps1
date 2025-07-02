$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/121.0.5581.0/win/Opera_Developer_121.0.5581.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/121.0.5581.0/win/Opera_Developer_121.0.5581.0_Setup_x64.exe'
  checksum       = 'bbc0a74b6390c24598e6b5d98efb592c745ec4d165eb96429a25a681fbe3aab6'
  checksum64     = 'ab3c4081dc0b6da70db0963432b3e39adb751374304a0bfca81c4ef08579595d'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '121.0.5581.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
