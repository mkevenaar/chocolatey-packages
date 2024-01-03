$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/107.0.5035.0/win/Opera_Developer_107.0.5035.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/107.0.5035.0/win/Opera_Developer_107.0.5035.0_Setup_x64.exe'
  checksum       = 'd2cf9f29476ef1cbe5ad93f27d49cff4c9a7c012ffd3470bb75933bfc0ad6726'
  checksum64     = '7cfe98b068392d3a18212ce965b450fe00d398d4473f951a8bf8dd1cf73ae388'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '107.0.5035.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
