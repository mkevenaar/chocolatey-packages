$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/66.0.3515.21/win/Opera_beta_66.0.3515.21_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/66.0.3515.21/win/Opera_beta_66.0.3515.21_Setup_x64.exe'
  checksum       = '9ffa95d047ebeb3f311d6137ad373c68a9f6f2c64fbce20084f709bc0152895b'
  checksum64     = '0a2602ede98248896e1dde036e1cd2d64784a10f344a54f902b4b5d3e9cd73d6'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '66.0.3515.21'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
