$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/113.0.5208.0/win/Opera_Developer_113.0.5208.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/113.0.5208.0/win/Opera_Developer_113.0.5208.0_Setup_x64.exe'
  checksum       = 'c78feaeea124f737efc26a70938de1d91e919e671df6eec682ce29b2fcfee58c'
  checksum64     = '74cabe6b861d802537c1f22fd3b528351f9b6b0e2fc0f39cc0221ac67e03fa58'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '113.0.5208.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
