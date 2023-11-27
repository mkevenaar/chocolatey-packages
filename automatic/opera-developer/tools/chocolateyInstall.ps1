$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/106.0.4998.0/win/Opera_Developer_106.0.4998.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/106.0.4998.0/win/Opera_Developer_106.0.4998.0_Setup_x64.exe'
  checksum       = 'ab225054f4ad435e7527258ce8417b2dfbdd6eec4ef524a3dd309f568ca2e9f8'
  checksum64     = 'f9ec15ab4a646d0a6ef8fb86afc3603540b8a6aa64b68ffc2424eb0955214d3f'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '106.0.4998.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
