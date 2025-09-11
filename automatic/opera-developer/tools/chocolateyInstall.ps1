$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/123.0.5652.0/win/Opera_Developer_123.0.5652.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/123.0.5652.0/win/Opera_Developer_123.0.5652.0_Setup_x64.exe'
  checksum       = '4e3c95bca9fa369655f4df9dbd9f4388ff05a5754fa24c99321761282721f65e'
  checksum64     = '2e3bd14f6880b5ef1341f16db24ec6244c7146ac39934f09583416c0c1999971'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '123.0.5652.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
