$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/65.0.3450.0/win/Opera_Developer_65.0.3450.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/65.0.3450.0/win/Opera_Developer_65.0.3450.0_Setup_x64.exe'
  checksum       = '4419619651c7ba5a96dbc0ae559cd44a2f27b96c95a95d620912ee8ca8250053'
  checksum64     = 'b58d80500ee97dd2cf416b7e121b8ab1dec7991373cee923790f89edf64ec9cb'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '65.0.3450.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
