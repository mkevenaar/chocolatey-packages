$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/77.0.4054.91/win/Opera_beta_77.0.4054.91_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/77.0.4054.91/win/Opera_beta_77.0.4054.91_Setup_x64.exe'
  checksum       = '39c834cb008ead538f5b4c6715f2ec789842019c716bcb63c7a7371882f38d59'
  checksum64     = '4b8279abd1bc7d3024dfe12c2fbd92395cc2dc8766a32204c5ce7478f5567aeb'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '77.0.4054.91'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
