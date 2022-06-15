$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/89.0.4447.12/win/Opera_beta_89.0.4447.12_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/89.0.4447.12/win/Opera_beta_89.0.4447.12_Setup_x64.exe'
  checksum       = '7ba9e652da4732b57fd69dedee35992c289ef35ad89943eeba39066dadde02e5'
  checksum64     = 'cd7519f5217c55ed0d34b30505f4b23551cf4e49667e3f12e783193ac3ac2ce4'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '89.0.4447.12'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
