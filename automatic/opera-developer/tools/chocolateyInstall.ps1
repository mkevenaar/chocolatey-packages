$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/124.0.5691.0/win/Opera_Developer_124.0.5691.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/124.0.5691.0/win/Opera_Developer_124.0.5691.0_Setup_x64.exe'
  checksum       = '077d9218905e4d3d355196c066397101e742eb64cbca75195b14c569344fa51c'
  checksum64     = '51b8a73b1561ff9bb79c86c929bbad4b3b32cf0195a011707cb16bc63f8efd41'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '124.0.5691.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
