$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/97.0.4719.11/win/Opera_beta_97.0.4719.11_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/97.0.4719.11/win/Opera_beta_97.0.4719.11_Setup_x64.exe'
  checksum       = '6d26c4b30afe6bfb7fef0677e9cc282816949b4e938c8cf1d83a0a71fe501015'
  checksum64     = 'cb37e84d27fdb47971e0b953cea101f0c071667f0eaddf3255c06c74b4aac110'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '97.0.4719.11'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
