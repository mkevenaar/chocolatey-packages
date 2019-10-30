$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/65.0.3467.24/win/Opera_beta_65.0.3467.24_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/65.0.3467.24/win/Opera_beta_65.0.3467.24_Setup_x64.exe'
  checksum       = 'c58b2f1232d43e7045a5232c70f41b572f46879478656d80f17efe51a590352f'
  checksum64     = 'fe61bfed1c926bc2f3f51521cdb65d578afe6efae72f93fd40eca8828f956a12'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '65.0.3467.24'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
