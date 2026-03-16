$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/130.0.5839.0/win/Opera_Developer_130.0.5839.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/130.0.5839.0/win/Opera_Developer_130.0.5839.0_Setup_x64.exe'
  checksum       = '72aba925d67a37a7d68ab09cc1668758e1a2d3d45d017353d909502acf9a9765'
  checksum64     = '68ee1c759e56b5ba3899522efdbd3acd00b1820ab6555380f2b577032352dd71'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '130.0.5839.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
