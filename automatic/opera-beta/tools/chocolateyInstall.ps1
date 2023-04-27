$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/98.0.4759.21/win/Opera_beta_98.0.4759.21_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/98.0.4759.21/win/Opera_beta_98.0.4759.21_Setup_x64.exe'
  checksum       = '44e8341f4b0c2f059a24bc9c2597db3bbaab34ad7ee38390ef93f3e97e73aaab'
  checksum64     = '23cab612b63feda2e72fa6faaf06deb4b97ad1ecd164157a5ac03cc5426eef87'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '98.0.4759.21'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
