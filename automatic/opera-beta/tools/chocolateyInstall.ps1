$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/76.0.4017.5/win/Opera_beta_76.0.4017.5_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/76.0.4017.5/win/Opera_beta_76.0.4017.5_Setup_x64.exe'
  checksum       = '4095daef10936cdf5307a701bf86541c6805f3742a282b2c2ce1ca647634cf2d'
  checksum64     = '96f5cb0aa11d0697f0f4f1fc36cc927b15ab3491a1500ba4cf81eec899a25df7'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '76.0.4017.5'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
