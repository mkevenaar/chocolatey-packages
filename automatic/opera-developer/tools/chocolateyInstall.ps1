$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/103.0.4899.0/win/Opera_Developer_103.0.4899.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/103.0.4899.0/win/Opera_Developer_103.0.4899.0_Setup_x64.exe'
  checksum       = '1ba224c4b77cb2b3a84eb45b2c3689780bc58dca214d82f7975bae2b0534b850'
  checksum64     = '238afc8c64f7856ef9ca5ec275b3d31c9cfee014387f9effae1510ce5bc8b1d4'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '103.0.4899.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
