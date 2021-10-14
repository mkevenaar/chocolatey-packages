$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/81.0.4196.11/win/Opera_beta_81.0.4196.11_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/81.0.4196.11/win/Opera_beta_81.0.4196.11_Setup_x64.exe'
  checksum       = 'c9f878474cf9eec9f129374ca7f7a6e70725978f3c6ab8d531f4381acaca4cfc'
  checksum64     = '28b90a54541f987775bef82351ab9501c4ec5737d2aceed9edb4ea67095dbe9e'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '81.0.4196.11'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
