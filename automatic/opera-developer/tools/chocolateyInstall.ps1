$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/115.0.5314.0/win/Opera_Developer_115.0.5314.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/115.0.5314.0/win/Opera_Developer_115.0.5314.0_Setup_x64.exe'
  checksum       = 'd8c60c87ec4324ed9c08d83746d0c92fa70ff905019f7afba2340915e7082f07'
  checksum64     = 'e2e08f14980ab3455970c70f4a52d358b799335caf7fb0fcee0cbfb685e6cda6'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '115.0.5314.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
