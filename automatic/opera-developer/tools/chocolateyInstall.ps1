$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/91.0.4505.0/win/Opera_Developer_91.0.4505.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/91.0.4505.0/win/Opera_Developer_91.0.4505.0_Setup_x64.exe'
  checksum       = 'd1e7f794a70bd199b3007f8759e6825f4f6a46c250722146659a6fa11133f1df'
  checksum64     = '7aa9c85b482e168a6c442df50495446e0176e041f6a697b6c628660d54f26a16'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '91.0.4505.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
