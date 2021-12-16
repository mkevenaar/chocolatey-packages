$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/83.0.4254.9/win/Opera_beta_83.0.4254.9_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/83.0.4254.9/win/Opera_beta_83.0.4254.9_Setup_x64.exe'
  checksum       = '017d445c9e58240c2b8d75ad0a03b539b1b311d071ee78a1595baa0b716b14ea'
  checksum64     = '6149fc0b1ccd2f80d3cbbcf58a58d4feae514779aa25bad4dc48f202b78640a7'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '83.0.4254.9'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
