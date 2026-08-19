$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/136.0.5995.0/win/Opera_Developer_136.0.5995.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/136.0.5995.0/win/Opera_Developer_136.0.5995.0_Setup_x64.exe'
  checksum       = 'fa82e51c9ed004da76deb63c701cfc6b29c009dc6bb93709776bda04adff749b'
  checksum64     = 'aef903f6accc5b017f5ffc9f273de89fa934159b0fa6ea33c38b792701e1bd58'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '136.0.5995.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
