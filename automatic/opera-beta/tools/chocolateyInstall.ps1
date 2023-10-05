$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/104.0.4944.3/win/Opera_beta_104.0.4944.3_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/104.0.4944.3/win/Opera_beta_104.0.4944.3_Setup_x64.exe'
  checksum       = 'b4bf3ef066419ff9ee464a5da42af7924a5c057f563fb1ecf001176c778ec695'
  checksum64     = 'a08ad72c82a2f4da9096b9745a1493740b33524f0d096e54bbe27ebbc3e75027'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '104.0.4944.3'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
