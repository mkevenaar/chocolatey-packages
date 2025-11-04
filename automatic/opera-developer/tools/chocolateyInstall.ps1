$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/125.0.5707.0/win/Opera_Developer_125.0.5707.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/125.0.5707.0/win/Opera_Developer_125.0.5707.0_Setup_x64.exe'
  checksum       = 'dd0ece4e72f5b5e3f85e1031cecb0cf52eb88cbfa2aecc1cf787e738e52e82c0'
  checksum64     = '00432ef66c281f561d1ec4d3697924885d9bfed10fbcf1ecffb72f1cc2916248'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '125.0.5707.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
