$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/89.0.4447.33/win/Opera_beta_89.0.4447.33_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/89.0.4447.33/win/Opera_beta_89.0.4447.33_Setup_x64.exe'
  checksum       = 'eb64a24ca71d7b2a44d492476b63bbef1bfcc7be9c601e9b58f7931a3c16e86a'
  checksum64     = 'f090fda6159052a76811cf9939b41196dba0b40097a3af96f97fa1865118b735'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '89.0.4447.33'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
