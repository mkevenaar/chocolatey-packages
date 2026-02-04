$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/128.0.5799.0/win/Opera_Developer_128.0.5799.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/128.0.5799.0/win/Opera_Developer_128.0.5799.0_Setup_x64.exe'
  checksum       = '8e1c6170adac87733637bac3ef23daa63c7efc7376b00062bd14dcd03c186488'
  checksum64     = '3a244427d3e15e0dc36fc0391c1ef0dca2beb20f08aed3fa681eea510c2ea36b'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '128.0.5799.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
