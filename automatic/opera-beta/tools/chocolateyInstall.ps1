$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/73.0.3856.208/win/Opera_beta_73.0.3856.208_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/73.0.3856.208/win/Opera_beta_73.0.3856.208_Setup_x64.exe'
  checksum       = 'ae647391a56146d84f9651670d07dde10c91cacd57c93965868681657aa8b5da'
  checksum64     = '6a546a14a51f096872a71c03675003cc4c0f2fd99601786eb7c40759480c6dd8'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '73.0.3856.208'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
