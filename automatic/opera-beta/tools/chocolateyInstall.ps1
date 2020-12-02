$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/73.0.3856.235/win/Opera_beta_73.0.3856.235_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/73.0.3856.235/win/Opera_beta_73.0.3856.235_Setup_x64.exe'
  checksum       = '469d4eb1999c890dae6b651f5f8ebbb7fa514112f87fdd24ea39cdb11894bb31'
  checksum64     = '82d5a213abc6d3084c56117ba5f8943347a9589f5b6ec624307ba3dea7464ec3'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '73.0.3856.235'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
