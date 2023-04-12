$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/99.0.4765.0/win/Opera_Developer_99.0.4765.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/99.0.4765.0/win/Opera_Developer_99.0.4765.0_Setup_x64.exe'
  checksum       = '688eeef9d553aa20164a54375d9b17a5f0c1daee1317fb797391713b14709f20'
  checksum64     = '77a8ef5adaf041ae0333a879befd128f42f99acbeaaaa8f4ef805306f0f09381'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '99.0.4765.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
