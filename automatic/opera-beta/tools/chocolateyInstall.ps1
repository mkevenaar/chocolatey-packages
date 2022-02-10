$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/84.0.4316.9/win/Opera_beta_84.0.4316.9_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/84.0.4316.9/win/Opera_beta_84.0.4316.9_Setup_x64.exe'
  checksum       = '3a2691883ce6749867af2a821112e0a385505d0c5351c833771cac3e8be7b1cf'
  checksum64     = 'ab790a7c550919b3a83080841cf2afb2982a83889fd05e1325c49b314d305b82'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '84.0.4316.9'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
