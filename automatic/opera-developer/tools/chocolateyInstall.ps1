$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/94.0.4604.0/win/Opera_Developer_94.0.4604.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/94.0.4604.0/win/Opera_Developer_94.0.4604.0_Setup_x64.exe'
  checksum       = '912616f8fa53d3330cf8d379600aafe2abfa50fd017690fb6a5e96cb69c90c99'
  checksum64     = 'b83613ecde63ab1386a9b66c9fe42bf7ab814d5574c0ecce915355a30dcbf9ff'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '94.0.4604.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
