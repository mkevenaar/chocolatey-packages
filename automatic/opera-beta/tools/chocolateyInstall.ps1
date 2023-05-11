$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/99.0.4788.6/win/Opera_beta_99.0.4788.6_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/99.0.4788.6/win/Opera_beta_99.0.4788.6_Setup_x64.exe'
  checksum       = 'f94c7406b2f91ebbce19b9618ce8d1a3c7d59a4a0679f4917089d5367a9db526'
  checksum64     = 'bb34edc390c3e91c2e7e5ba3a651fb44f1593280f9e25f82835e6d8b7ab5a4d3'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '99.0.4788.6'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
