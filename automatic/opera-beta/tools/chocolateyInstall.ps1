$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/74.0.3911.42/win/Opera_beta_74.0.3911.42_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/74.0.3911.42/win/Opera_beta_74.0.3911.42_Setup_x64.exe'
  checksum       = 'ca9c16e3bf4af2351999ca6df9260291bc92aef9c0dc7980505f74547b6d21bb'
  checksum64     = '9301847133fca77e9ebf9ccb0fddd7f034119f2b51b7ed7590d898982bcccfb3'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '74.0.3911.42'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
