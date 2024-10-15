$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/115.0.5320.0/win/Opera_Developer_115.0.5320.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/115.0.5320.0/win/Opera_Developer_115.0.5320.0_Setup_x64.exe'
  checksum       = 'aff83911bebd00cf43667a7ef8cde57a815809607cc68106641fffbad48b5e75'
  checksum64     = '061151d61161d2f1b4fcac30469f21802d26ba5a846c2cfd6eb0c8ee13162c79'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '115.0.5320.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
