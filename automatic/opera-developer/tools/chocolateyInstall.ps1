$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/125.0.5727.1/win/Opera_Developer_125.0.5727.1_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/125.0.5727.1/win/Opera_Developer_125.0.5727.1_Setup_x64.exe'
  checksum       = '015721d75e30acca9c8176fb453c2b67d3913d3ae56049958a14b1889ee13193'
  checksum64     = 'f3dd771ca2f6ab71b192816a310981c07ff88cb95752a88dca83a6ac5081cac0'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '125.0.5727.1'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
