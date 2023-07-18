$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/101.0.4843.19/win/Opera_beta_101.0.4843.19_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/101.0.4843.19/win/Opera_beta_101.0.4843.19_Setup_x64.exe'
  checksum       = '3de62daf44dff45d14078693026bbb4e590c8b46c4da2dd2d841e493cffd7752'
  checksum64     = 'e9bda22ac83c5737aa949d6422961fa84b006aa7f95cead2fe8886c4b4f19e45'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '101.0.4843.19'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
