$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/95.0.4635.20/win/Opera_beta_95.0.4635.20_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/95.0.4635.20/win/Opera_beta_95.0.4635.20_Setup_x64.exe'
  checksum       = '1a9cc97277c96b02e49c6d5b699c780fe4914eafef20cc3da76363657902c1e4'
  checksum64     = 'f060f777fa9fca16ff1bee0c3ce73da57da611b9b2de18a7ee9b576cb363cf10'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '95.0.4635.20'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
