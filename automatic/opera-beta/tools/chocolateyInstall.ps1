$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/69.0.3686.12/win/Opera_beta_69.0.3686.12_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/69.0.3686.12/win/Opera_beta_69.0.3686.12_Setup_x64.exe'
  checksum       = '20ad3dbdc6f458bb1dd71fc2b17b77dfb46a909b0ed436a835c92941ce369449'
  checksum64     = 'caa3e5427364af4e8fae4d9d215992479bf2722356b8f9f90d4d842124dc7427'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '69.0.3686.12'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
