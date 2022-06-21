$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/89.0.4447.20/win/Opera_beta_89.0.4447.20_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/89.0.4447.20/win/Opera_beta_89.0.4447.20_Setup_x64.exe'
  checksum       = '745092e4e00b2a72933f0a4158772b2ccd69a77b2b312644ed0762cdaa7a47c2'
  checksum64     = 'a74ee175ba03728a24861f39121a8786bde6c0948b6f4bf575329aecac420ae5'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '89.0.4447.20'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
