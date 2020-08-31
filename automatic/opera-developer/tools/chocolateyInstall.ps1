$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/72.0.3798.0/win/Opera_Developer_72.0.3798.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/72.0.3798.0/win/Opera_Developer_72.0.3798.0_Setup_x64.exe'
  checksum       = 'ffd2655d7c2d0de84d559e636bdfc54fb536ec18df68d887764f94721263a778'
  checksum64     = '8d13d75c57b408c097019c07b1346672c3befa40b9f552e81a974272cc1c2da5'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '72.0.3798.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
