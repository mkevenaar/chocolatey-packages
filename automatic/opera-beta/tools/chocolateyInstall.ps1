$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/81.0.4196.27/win/Opera_beta_81.0.4196.27_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/81.0.4196.27/win/Opera_beta_81.0.4196.27_Setup_x64.exe'
  checksum       = 'e8d61f7920490aee9d0b88a06e2accb9e827a991f6abdb0ff339fc146b49fa83'
  checksum64     = '43a5edab94428e809b7d2507655d810a63166bca405cc27868fba29922aba0bf'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '81.0.4196.27'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
