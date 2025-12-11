$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/126.0.5744.0/win/Opera_Developer_126.0.5744.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/126.0.5744.0/win/Opera_Developer_126.0.5744.0_Setup_x64.exe'
  checksum       = 'b791dcfd1df63c1197176e27b61117f4d2cccff4c06237c888b8a781cca2ab29'
  checksum64     = '68c06ff9b0b5c8278dd53330e7ae314bf52de4fe736997b2148b03efd56751b4'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '126.0.5744.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
