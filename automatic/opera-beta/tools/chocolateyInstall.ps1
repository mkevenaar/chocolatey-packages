$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/63.0.3368.14/win/Opera_beta_63.0.3368.14_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/63.0.3368.14/win/Opera_beta_63.0.3368.14_Setup_x64.exe'
  checksum       = 'a327c894625686af8683760e10e056d53179721b40f43743f6c9305c9fb85ea6'
  checksum64     = 'c05a64da2f2251e1c0993a1a16e3642842e21b2f6a2ea2a6ab15b168f8f64293'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '63.0.3368.14'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
