$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/72.0.3807.0/win/Opera_Developer_72.0.3807.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/72.0.3807.0/win/Opera_Developer_72.0.3807.0_Setup_x64.exe'
  checksum       = '14e8905cc50e3c24bc5408dd6871f0fe18361aa8efecc5fdf2f943f6668609bb'
  checksum64     = '7420a1e77a17dcdcb30bcf0b3cda6dd9afdd460062befb787ed8f098d72d27b1'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '72.0.3807.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
