$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/96.0.4691.0/win/Opera_Developer_96.0.4691.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/96.0.4691.0/win/Opera_Developer_96.0.4691.0_Setup_x64.exe'
  checksum       = 'c346f0f9e7a71ceed304832ed45c0528bf820ddd45ebe0f1aee7ebda91fb2c91'
  checksum64     = 'a565155bf1af4e9853a3764956f73153fad3134c4ecaec24a717a946c2f09b74'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '96.0.4691.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
