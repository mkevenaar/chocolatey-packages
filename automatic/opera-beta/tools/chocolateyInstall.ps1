$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/73.0.3856.31/win/Opera_beta_73.0.3856.31_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/73.0.3856.31/win/Opera_beta_73.0.3856.31_Setup_x64.exe'
  checksum       = '2d7ae58bf320d91a61cc38dacc09e10b65b8c834214eff0723faac235ab397f4'
  checksum64     = 'a2c18a938d31c6ee75bf93725c174783c067c2252ed21b9855a1c9b9ba0294c1'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '73.0.3856.31'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
