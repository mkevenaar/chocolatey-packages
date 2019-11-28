$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/66.0.3515.3/win/Opera_beta_66.0.3515.3_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/66.0.3515.3/win/Opera_beta_66.0.3515.3_Setup_x64.exe'
  checksum       = '8dc6db3990f799a3db0919321ddba5870f235f98d1b36659923c550d02810a24'
  checksum64     = 'a5d76ec2b789f80515b6fb9685e45594f76623b51a0fb065c0e224ac2612b880'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '66.0.3515.3'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
