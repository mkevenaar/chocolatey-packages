$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/67.0.3575.23/win/Opera_beta_67.0.3575.23_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/67.0.3575.23/win/Opera_beta_67.0.3575.23_Setup_x64.exe'
  checksum       = '4d6331fe327144281185af4ea496657903b800f7b86494fde6d4f431fe5c64da'
  checksum64     = 'e3b8bf305110ae990a79ca738498f358089c4861b999f0001a9bec38f4ba16c8'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '67.0.3575.23'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
