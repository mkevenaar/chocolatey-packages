$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/100.0.4796.0/win/Opera_Developer_100.0.4796.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/100.0.4796.0/win/Opera_Developer_100.0.4796.0_Setup_x64.exe'
  checksum       = '244f09824793e822a9379d3b9f58a2fc379d0744d500903db1398a511b2f1e09'
  checksum64     = '0efd6596eabc35251e40189668bf349e076ce92cc09e294371b39650b985824b'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '100.0.4796.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
