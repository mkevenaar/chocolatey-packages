$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/63.0.3347.0/win/Opera_Developer_63.0.3347.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/63.0.3347.0/win/Opera_Developer_63.0.3347.0_Setup_x64.exe'
  checksum       = '977b6f898fe2136a17bd6df329cb8d1a0d85d21a90faa0cc452982986e490de5'
  checksum64     = '8206c04a2d2797a9bbe2dbf07f54a38ceefffb3637e1e756b08fad465d0d5a49'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '63.0.3347.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
