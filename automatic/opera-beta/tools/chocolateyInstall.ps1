$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/68.0.3618.3/win/Opera_beta_68.0.3618.3_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/68.0.3618.3/win/Opera_beta_68.0.3618.3_Setup_x64.exe'
  checksum       = '9d94dd5ea7313c58504f68819637f176f18c5fe66142bb94d8ad92878ac75f40'
  checksum64     = 'dd11d5974632a35c561f645ce016e1a0906aa2766c6cc7029470d49531bd7006'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '68.0.3618.3'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
