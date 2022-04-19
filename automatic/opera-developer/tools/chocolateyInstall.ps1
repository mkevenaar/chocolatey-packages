$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/88.0.4395.0/win/Opera_Developer_88.0.4395.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/88.0.4395.0/win/Opera_Developer_88.0.4395.0_Setup_x64.exe'
  checksum       = '724828e9f514baa7f89306501d03fd8874bf70fcff4c3028e177ab544ea56b1a'
  checksum64     = 'a970b471ab845025b8c3f46e2db7f2ee99e99a507cb4491a1bc5754849b6ab97'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '88.0.4395.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
