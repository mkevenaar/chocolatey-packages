$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/90.0.4480.30/win/Opera_beta_90.0.4480.30_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/90.0.4480.30/win/Opera_beta_90.0.4480.30_Setup_x64.exe'
  checksum       = 'f99b143eefa6742984109664fb1db9b84cdcf8f7b6694820c247fdfebffefd62'
  checksum64     = '4df706dabf4edf2e789ef27e4c07fc46333cbeb4b3f6cb8eb62149efa5a5d5c6'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '90.0.4480.30'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
