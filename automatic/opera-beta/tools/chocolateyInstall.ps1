$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/76.0.4017.59/win/Opera_beta_76.0.4017.59_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/76.0.4017.59/win/Opera_beta_76.0.4017.59_Setup_x64.exe'
  checksum       = '30c26c7fe753589b69b2b3274682483a4cd05c7f15a8c688f1b284a7c966242c'
  checksum64     = 'b759c008575790740bbba0ee0b516e15e919d9bea4926c2fd8932cc8fcd84299'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '76.0.4017.59'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
