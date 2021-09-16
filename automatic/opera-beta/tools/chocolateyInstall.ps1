$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/80.0.4170.4/win/Opera_beta_80.0.4170.4_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/80.0.4170.4/win/Opera_beta_80.0.4170.4_Setup_x64.exe'
  checksum       = 'f695f1a770736cb9323244fec7b480425e11f951de17694876f63f501894bb7d'
  checksum64     = '8362773002a55fccc9135681a04db17f547d31b88f465398f416470b15fa13ba'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '80.0.4170.4'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
