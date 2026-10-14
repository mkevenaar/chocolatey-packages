$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/139.0.6051.0/win/Opera_Developer_139.0.6051.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/139.0.6051.0/win/Opera_Developer_139.0.6051.0_Setup_x64.exe'
  checksum       = 'cd1ae783e64cd2e9ee68ccc0ddc4ac54f55f69533569ff0c872b4755cafb2ec8'
  checksum64     = '018a3f5b5079773c4c14182cd4b1b11f561e7fa22d12291086a29dccef38ea08'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '139.0.6051.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
