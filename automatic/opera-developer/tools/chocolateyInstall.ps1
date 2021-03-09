$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/76.0.3989.0/win/Opera_Developer_76.0.3989.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/76.0.3989.0/win/Opera_Developer_76.0.3989.0_Setup_x64.exe'
  checksum       = 'bbc0778249a9890d67b7ece543bb51f8a55de55db165f99b00b6674d866838cf'
  checksum64     = '91cd3e0c7fcf041a7e8d647a2c491f1df71f0139d59fb37212912e5c6aa88275'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '76.0.3989.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
