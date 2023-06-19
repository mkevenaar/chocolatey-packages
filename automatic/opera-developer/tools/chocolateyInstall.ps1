$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/101.0.4836.0/win/Opera_Developer_101.0.4836.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/101.0.4836.0/win/Opera_Developer_101.0.4836.0_Setup_x64.exe'
  checksum       = 'eef9db20419840ef46e8ce24813677b36e38edb20cfbd45c7137f328963ebecb'
  checksum64     = '987884716e57a8c8458c1e28ab2e496c8bd82ecb5541d52e9096b0e3daf6b431'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '101.0.4836.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
