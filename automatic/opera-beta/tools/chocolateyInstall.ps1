$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/101.0.4843.10/win/Opera_beta_101.0.4843.10_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/101.0.4843.10/win/Opera_beta_101.0.4843.10_Setup_x64.exe'
  checksum       = 'e14f4a097fcae49fac6b9fde51653b59f9d9ad5bb9b75b563d2414d09d0a50f4'
  checksum64     = '75401e04644996d9b83c565dc662f48ea0a5c86d192f2a3b1e3b5a8b6c70a28f'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '101.0.4843.10'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
