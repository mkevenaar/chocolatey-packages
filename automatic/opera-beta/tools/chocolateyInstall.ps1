$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/100.0.4815.13/win/Opera_beta_100.0.4815.13_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/100.0.4815.13/win/Opera_beta_100.0.4815.13_Setup_x64.exe'
  checksum       = '4bfefe71c73b1cc989ae3919aa1d114194def1d824837e7ad82c55186eeda4b5'
  checksum64     = '4b7668806bec1db76950312d8f8a96a2db16081c034ff824a00454d9bc9cfc28'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '100.0.4815.13'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
