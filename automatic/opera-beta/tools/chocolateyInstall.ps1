$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/107.0.5045.8/win/Opera_beta_107.0.5045.8_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/107.0.5045.8/win/Opera_beta_107.0.5045.8_Setup_x64.exe'
  checksum       = '7109b2b8edfb1c51e50c7b03273fe83015a18c5a365897ffda58f65fb8739f86'
  checksum64     = 'ce43c2af8416eda8761804c30c611de5401b8bc25095cc195cb73166bc477a2f'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '107.0.5045.8'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
