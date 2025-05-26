$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/121.0.5544.0/win/Opera_Developer_121.0.5544.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/121.0.5544.0/win/Opera_Developer_121.0.5544.0_Setup_x64.exe'
  checksum       = '8b22068e881dec2978964ed94fbc80847aa4e707be78c010753b4db1d10464b4'
  checksum64     = 'd1322bdab1f1291a056a3aa6d7fc2fca3c3ea8a706905c8285778a74fe2a340d'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '121.0.5544.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
