$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/86.0.4363.15/win/Opera_beta_86.0.4363.15_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/86.0.4363.15/win/Opera_beta_86.0.4363.15_Setup_x64.exe'
  checksum       = '87212cbcbae2ad05c7b334566bd621d520c71767cd907473664e17d8f34086fb'
  checksum64     = 'fbfd2ca07e31dc3938802ab0458a4cee77718c7c8e147fc18561ea5870b3b0b3'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '86.0.4363.15'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
