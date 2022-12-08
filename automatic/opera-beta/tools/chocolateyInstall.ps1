$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/94.0.4606.19/win/Opera_beta_94.0.4606.19_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/94.0.4606.19/win/Opera_beta_94.0.4606.19_Setup_x64.exe'
  checksum       = 'd81e5e4338d3cd9e6d36f83cad438e7ae93c35dccc8c136cb9e9d248da66f318'
  checksum64     = '798b891962517dc689fa3e5affefe9c984ab1c25a775ce9fc90ecf55e3c80bda'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '94.0.4606.19'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
