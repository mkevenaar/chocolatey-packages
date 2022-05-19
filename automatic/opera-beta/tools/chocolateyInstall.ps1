$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/88.0.4412.13/win/Opera_beta_88.0.4412.13_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/88.0.4412.13/win/Opera_beta_88.0.4412.13_Setup_x64.exe'
  checksum       = 'd607352173f241692abb35ae5731ca3337c977afee4b861a4aa61414aa2b242f'
  checksum64     = '6907f3065ef969580eb39f6c1dde8b20c2d4e2c149b774e83209c35b046a4b45'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '88.0.4412.13'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
