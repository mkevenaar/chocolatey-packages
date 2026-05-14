$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/132.0.5898.0/win/Opera_Developer_132.0.5898.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/132.0.5898.0/win/Opera_Developer_132.0.5898.0_Setup_x64.exe'
  checksum       = 'bafb6318c36617ac36c4b15e7b6e880db17bee47fded497fbfb6952b9e3fb4ef'
  checksum64     = '657c18654928b998082364509d94c705b8bf1bf4ebec1fd6f1446f7bd7f7152c'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '132.0.5898.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
