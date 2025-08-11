$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/122.0.5621.0/win/Opera_Developer_122.0.5621.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/122.0.5621.0/win/Opera_Developer_122.0.5621.0_Setup_x64.exe'
  checksum       = 'f87dbcf2f4a1590d72cea88ff8a3e44cb8b2837c122da15e108620579b1c695e'
  checksum64     = 'ff352ebd602fdb93d96fb979ffd3d6d3f661ce35adc0c93a87ed8f9541301bac'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '122.0.5621.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
