$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/119.0.5474.0/win/Opera_Developer_119.0.5474.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/119.0.5474.0/win/Opera_Developer_119.0.5474.0_Setup_x64.exe'
  checksum       = 'b23157467acfd645c792b4ae8136387e9ba73d0e805c5c50c0fee72684b55cf0'
  checksum64     = 'bbcf6c60180a4f8c87569550c04b02f812c7e5a9d694709f74ce25caaeacd7a9'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '119.0.5474.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
