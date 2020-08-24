$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/72.0.3791.0/win/Opera_Developer_72.0.3791.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/72.0.3791.0/win/Opera_Developer_72.0.3791.0_Setup_x64.exe'
  checksum       = 'f059700e6a1f65fe1016a8ac5d93a441c2fe319ecf9ca413bbd3e4b6edbf539a'
  checksum64     = '18296c3ce9343fd91d89197385fc2897b558d402d64a3e44d37fea551c48f444'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '72.0.3791.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
