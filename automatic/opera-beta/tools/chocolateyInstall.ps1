$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/68.0.3618.5/win/Opera_beta_68.0.3618.5_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/68.0.3618.5/win/Opera_beta_68.0.3618.5_Setup_x64.exe'
  checksum       = '91a2c922fc5b4a6d6b3d0c5cd8d2416df6b9c50a9b10727f9396b783acc09e8c'
  checksum64     = 'c9e6b05c098fb1d49f069cd36f28d33765e3d6b39b4ffaf5b16acb75d1670c3a'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '68.0.3618.5'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
