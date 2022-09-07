$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/91.0.4516.10/win/Opera_beta_91.0.4516.10_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/91.0.4516.10/win/Opera_beta_91.0.4516.10_Setup_x64.exe'
  checksum       = '91de26bb928eb46db944a9be0038b10a1664c95eb97c7becfdc556ebb6d55759'
  checksum64     = 'cc9bd0a75eb2d3ef06de116215c4ff9ee6298a1b5f65c8e4c6ba5131461b058b'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '91.0.4516.10'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
