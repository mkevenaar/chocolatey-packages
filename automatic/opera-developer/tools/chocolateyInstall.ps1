$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/65.0.3459.0/win/Opera_Developer_65.0.3459.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/65.0.3459.0/win/Opera_Developer_65.0.3459.0_Setup_x64.exe'
  checksum       = '51e44a47decbc7bfe295e7cd1978c722fa1252a5cdc662e51af1ee04354d160f'
  checksum64     = 'e43e68a2fc62e5aeb8c060e7d1dbeec3b18b3d77ed666258ba8095ab8c4f5f0d'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '65.0.3459.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
