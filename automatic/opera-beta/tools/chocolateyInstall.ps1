$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/67.0.3575.13/win/Opera_beta_67.0.3575.13_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/67.0.3575.13/win/Opera_beta_67.0.3575.13_Setup_x64.exe'
  checksum       = 'c6fbe1fb02e53fc867d83ea85666be8c2975e6fe0ba84b1f1636e147a81f5f5f'
  checksum64     = '565656a45aaf72add00d4d2f98f4e2740adf1f99b977a03c87ab8251891a02f5'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '67.0.3575.13'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
