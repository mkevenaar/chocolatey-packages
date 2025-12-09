$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/126.0.5742.0/win/Opera_Developer_126.0.5742.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/126.0.5742.0/win/Opera_Developer_126.0.5742.0_Setup_x64.exe'
  checksum       = 'b6d497c704ddcd712f7c15cabf23c142b932d8071af0a817ef60cf9cd0e79d5b'
  checksum64     = 'd69f843cc51090159b2aa6451563c9d65e5dc1ce283ec407a0384aed3e96a010'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '126.0.5742.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
