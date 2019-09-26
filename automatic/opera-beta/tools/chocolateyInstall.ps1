$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/64.0.3417.32/win/Opera_beta_64.0.3417.32_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/64.0.3417.32/win/Opera_beta_64.0.3417.32_Setup_x64.exe'
  checksum       = '4e9f94f73fe26e628b1a7865e33f869686d8196775e06127490adf480e3455d2'
  checksum64     = '008079816909a84285cf024628a5e032672ad768a69a0e9c2b3859df4f1cf771'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '64.0.3417.32'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
