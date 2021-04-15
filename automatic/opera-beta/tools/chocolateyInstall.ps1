$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/76.0.4017.40/win/Opera_beta_76.0.4017.40_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/76.0.4017.40/win/Opera_beta_76.0.4017.40_Setup_x64.exe'
  checksum       = 'cf57f1ca3f439e9d05039dbef136ed28043c235d06f35a21c04ad842f1ac4c7b'
  checksum64     = '4585d53ffdc6431ba753c8179f44436c2e70dcfa1d3a817b053d371dc92b12ca'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '76.0.4017.40'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
