$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/67.0.3575.8/win/Opera_beta_67.0.3575.8_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/67.0.3575.8/win/Opera_beta_67.0.3575.8_Setup_x64.exe'
  checksum       = '43c0b2d455b2d01f2be89eb66457b802be0f6cb04dd7f23488c3a55385d9a9af'
  checksum64     = 'f9bfc59a816e0ae270eec9e9202ed44420840b69bd7b502e20878f6d80e17605'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '67.0.3575.8'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
