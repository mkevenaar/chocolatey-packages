$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/78.0.4093.79/win/Opera_beta_78.0.4093.79_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/78.0.4093.79/win/Opera_beta_78.0.4093.79_Setup_x64.exe'
  checksum       = 'a302921e4dc9a4905f6cf8400965fadf1a0cd018b887b36b8f9f068f6cb67286'
  checksum64     = '5218bd76cbc24101143a714ceef437749712e8e2c9cd48e49726013a89307559'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '78.0.4093.79'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
