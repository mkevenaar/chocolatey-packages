$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/85.0.4341.13/win/Opera_beta_85.0.4341.13_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/85.0.4341.13/win/Opera_beta_85.0.4341.13_Setup_x64.exe'
  checksum       = '1cc8b7b5d5f4667a65de472ace7c8f6fde4deca4cdef352eebd743a2849f8b79'
  checksum64     = '28e764d802acac1f43e10f07cc60db6276295c7e95e8888d974f25d573fd7be6'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '85.0.4341.13'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
