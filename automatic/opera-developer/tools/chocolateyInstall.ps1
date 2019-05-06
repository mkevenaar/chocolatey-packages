$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/60.0.3255.60/win/Opera_beta_60.0.3255.60_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/60.0.3255.60/win/Opera_beta_60.0.3255.60_Setup_x64.exe'
  checksum       = '2c3c9317b0839aac3f4482929161e5c7e20e9618dea9f0204c8fd6bc10f102af'
  checksum64     = 'd36b70468a591a27087586451a60b8c2e1ffcb4e4924d37857eb966d63217467'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '60.0.3255.60'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
