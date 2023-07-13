$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/101.0.4843.13/win/Opera_beta_101.0.4843.13_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/101.0.4843.13/win/Opera_beta_101.0.4843.13_Setup_x64.exe'
  checksum       = '9b8719024bff1e5d2e9bc5c4d298d36a508a3e3b240d2256a939c2ac2efd325f'
  checksum64     = '525d710150a4eb1ac1874c2facb5b1d45faa1f82289a785ae002d50308669856'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '101.0.4843.13'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
