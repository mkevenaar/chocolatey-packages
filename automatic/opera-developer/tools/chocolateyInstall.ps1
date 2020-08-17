$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/72.0.3784.0/win/Opera_Developer_72.0.3784.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/72.0.3784.0/win/Opera_Developer_72.0.3784.0_Setup_x64.exe'
  checksum       = '9334d6e91b0a315c593a3257f79713cc321b9acf6f2a4b1c2402b519db314094'
  checksum64     = '6d104fade9ffed9b7cff129a9f3dfda74358809b00a3bc1ec9ebd6d9bd7b692e'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '72.0.3784.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
