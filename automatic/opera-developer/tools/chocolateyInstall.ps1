$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/82.0.4210.0/win/Opera_Developer_82.0.4210.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/82.0.4210.0/win/Opera_Developer_82.0.4210.0_Setup_x64.exe'
  checksum       = '73320036a75e46b3905a53b7b4d20e74caae6b4a5de96fd2879e720ff3e8802e'
  checksum64     = 'd9cdde52591246420915f7cbeff6a6a33ba43fe79061cd4e3eb8f381c87efa1d'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '82.0.4210.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
