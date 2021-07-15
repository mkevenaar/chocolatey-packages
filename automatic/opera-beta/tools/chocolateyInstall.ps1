$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/78.0.4093.68/win/Opera_beta_78.0.4093.68_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/78.0.4093.68/win/Opera_beta_78.0.4093.68_Setup_x64.exe'
  checksum       = 'f27b67779c582e6742e3334a589ae7580bdc860354a2c622f456f8f5e9bbc57e'
  checksum64     = '7156baa3c04b7e33fc4b612b8362a48a0c132c3259f8a34a9adf3522053e2b33'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '78.0.4093.68'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
