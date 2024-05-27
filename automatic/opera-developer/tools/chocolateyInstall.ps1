$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/112.0.5179.0/win/Opera_Developer_112.0.5179.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/112.0.5179.0/win/Opera_Developer_112.0.5179.0_Setup_x64.exe'
  checksum       = '76f3ccb172a314681b7c8172e64b8ed4107798b562438f925276412536246a6a'
  checksum64     = '8c4f046060db8930cb61c64e686fc43dc434d4b6f035cb310255096b4ff0abd8'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '112.0.5179.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
