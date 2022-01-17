$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/84.0.4302.0/win/Opera_Developer_84.0.4302.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/84.0.4302.0/win/Opera_Developer_84.0.4302.0_Setup_x64.exe'
  checksum       = '3b23575f899eda9b2e806177361224f97ac0a820b1766e5648ed3f5692ab9dde'
  checksum64     = '7fc911bf902881c3e5c4d560ebfe096a0e5c53ee6c2dbc76b114c5dc7a251458'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '84.0.4302.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
