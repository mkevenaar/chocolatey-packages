$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/69.0.3686.2/win/Opera_beta_69.0.3686.2_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/69.0.3686.2/win/Opera_beta_69.0.3686.2_Setup_x64.exe'
  checksum       = 'e758d82f73c2b89a37f37938ac71814ddcfaeac767fc62d3a010fcbe72e64718'
  checksum64     = 'e8eb537105ded88220fba2951e203f7da614b9e6a8d9b4b04fe5cfcb17e8124f'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '69.0.3686.2'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
