$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/142.0.6095.0/win/Opera_Developer_142.0.6095.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/142.0.6095.0/win/Opera_Developer_142.0.6095.0_Setup_x64.exe'
  checksum       = 'd5ae41e7f625cf786bafde2cf403a653c299f006bb3eeb74ff8b93208927f7d9'
  checksum64     = '6204ce1b5a4231f402fb9329e2e41b9fcae1c2f01f6b55110fb32a34edd7d85c'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '142.0.6095.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
