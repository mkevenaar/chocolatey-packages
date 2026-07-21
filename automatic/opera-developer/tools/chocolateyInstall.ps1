$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/135.0.5966.0/win/Opera_Developer_135.0.5966.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/135.0.5966.0/win/Opera_Developer_135.0.5966.0_Setup_x64.exe'
  checksum       = 'a81de9aeb392ed9cc15d4a9234dd15ac7b88bb883ae32043322fafd400debf4b'
  checksum64     = '4fbbc5ed370048f032a88f35393aba4c4e16f5db6d619a78cfc2a144d236dfd9'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '135.0.5966.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
