$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/67.0.3541.0/win/Opera_Developer_67.0.3541.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/67.0.3541.0/win/Opera_Developer_67.0.3541.0_Setup_x64.exe'
  checksum       = '78755c208f7e189954c6fb2d79771624dc7fff8932261542b768b96a2da6dfbf'
  checksum64     = '2bd3b17558e430f329570410ef2461dab1037e32916f4cbbe73f0a72971f674d'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '67.0.3541.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
