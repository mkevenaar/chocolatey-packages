$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/92.0.4526.0/win/Opera_Developer_92.0.4526.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/92.0.4526.0/win/Opera_Developer_92.0.4526.0_Setup_x64.exe'
  checksum       = '78d430917526ccbe9bdb91f2fe6be045dd66604cb67ea78d6fe095327c80f3e1'
  checksum64     = '231df9dcf46792fff6aac3860cecb011202ab02576c8d704b61efa71f8898b72'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '92.0.4526.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
