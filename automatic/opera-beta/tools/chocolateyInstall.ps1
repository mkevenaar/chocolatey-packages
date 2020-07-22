$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/70.0.3728.59/win/Opera_beta_70.0.3728.59_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/70.0.3728.59/win/Opera_beta_70.0.3728.59_Setup_x64.exe'
  checksum       = 'fc56364839f973eb66de72fd189fef3add5351f8134b0f52eedbe206a24a1c59'
  checksum64     = '063116f33163fb9922f5ec79afc9eed8752711d785eb7ae9e7e77bc5ba38568c'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '70.0.3728.59'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
