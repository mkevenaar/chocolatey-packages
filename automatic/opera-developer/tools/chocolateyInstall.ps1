$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/109.0.5089.0/win/Opera_Developer_109.0.5089.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/109.0.5089.0/win/Opera_Developer_109.0.5089.0_Setup_x64.exe'
  checksum       = '0cb9169c70576811bd19f09e9eb4088ed2b539085c7dcf31d5b6293994474213'
  checksum64     = 'c7461ebd992c321cd3d5b0d705cb6d61360fc8b88301ffef53143be0b2bb702d'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '109.0.5089.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
