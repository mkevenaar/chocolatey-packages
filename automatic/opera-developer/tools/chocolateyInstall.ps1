$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/138.0.6038.0/win/Opera_Developer_138.0.6038.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/138.0.6038.0/win/Opera_Developer_138.0.6038.0_Setup_x64.exe'
  checksum       = '562398823800c100dad2f91a566331c4b813f6cb37d54cb492a099fb13ce738c'
  checksum64     = '12f87cc426d0d7d8ded5bcef908e4ee4b8e8b70b3ecd6e28202fbec1bd6cc29d'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '138.0.6038.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
