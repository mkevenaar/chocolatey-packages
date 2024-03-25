$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/110.0.5117.0/win/Opera_Developer_110.0.5117.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/110.0.5117.0/win/Opera_Developer_110.0.5117.0_Setup_x64.exe'
  checksum       = 'bae63c025bc34762f2fad535f2b6e233a34ae5698ec2446308add08409607d78'
  checksum64     = '23ad483acda14e3ab3fdfb83d04f97d6aabafd3c4b4712848d033e9c69d43fef'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '110.0.5117.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
