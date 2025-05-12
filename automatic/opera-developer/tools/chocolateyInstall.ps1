$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/120.0.5530.0/win/Opera_Developer_120.0.5530.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/120.0.5530.0/win/Opera_Developer_120.0.5530.0_Setup_x64.exe'
  checksum       = 'f9cee9a3a9376c0a2685e7371fe0d288cbe263ac89500566d41f4ce1fb750f58'
  checksum64     = '34357c77c81c36cc16a02fed947b5f3b8d5199e2f30795a80f54ab59cbf42703'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '120.0.5530.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
