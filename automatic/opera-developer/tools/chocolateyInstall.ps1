$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/107.0.5004.0/win/Opera_Developer_107.0.5004.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/107.0.5004.0/win/Opera_Developer_107.0.5004.0_Setup_x64.exe'
  checksum       = '4ac1b84d38a1854e139f2df25067ee5c72802b8bdd3c2f8b7dce68fe46d3dd21'
  checksum64     = '889fe3bd223d636cf0aeede16c8edfde3730ca6fb6e6a9cc304fbd6bb92f7e14'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '107.0.5004.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
