$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/81.0.4196.0/win/Opera_Developer_81.0.4196.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/81.0.4196.0/win/Opera_Developer_81.0.4196.0_Setup_x64.exe'
  checksum       = '9bbd57a39049940954e339cff6421fd57adb0595c5b60d989840933e4bc159fc'
  checksum64     = 'cfe73367d05e1e160361f3961645a922176ef48c297fc2a68125fa160d76d1aa'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '81.0.4196.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
