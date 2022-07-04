$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/90.0.4470.0/win/Opera_Developer_90.0.4470.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/90.0.4470.0/win/Opera_Developer_90.0.4470.0_Setup_x64.exe'
  checksum       = '9b1e0d29580dbc3c1f6ecc01f737bf15c92f242d2b16ae4d86a06203da0717a6'
  checksum64     = 'dd3136f27eebe6bf8211ad01b67d4762b7205771dcf15601dc5e75d4acfff03e'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '90.0.4470.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
