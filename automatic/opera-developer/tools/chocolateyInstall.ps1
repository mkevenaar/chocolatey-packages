$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/70.0.3707.0/win/Opera_Developer_70.0.3707.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/70.0.3707.0/win/Opera_Developer_70.0.3707.0_Setup_x64.exe'
  checksum       = '1c89a0c9d909d1a0b73f06b820136a281f264b9468a2b827f1ddf991fdea472f'
  checksum64     = 'b2fcf26060058b3e6929482ef5b7ce621b989817f792d3f10ca52457cca0d632'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '70.0.3707.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
