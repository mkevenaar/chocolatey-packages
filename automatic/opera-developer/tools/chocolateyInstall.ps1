$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/97.0.4718.0/win/Opera_Developer_97.0.4718.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/97.0.4718.0/win/Opera_Developer_97.0.4718.0_Setup_x64.exe'
  checksum       = 'c8d535c91b71f026d3b9f8fbe6018964c2a54132d0e817daf209d9fa30c083af'
  checksum64     = '06b75729236e82fdc9ad7ce9e5d2a74b9fd83ba7fb2a239d47374e86ed3969bf'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '97.0.4718.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
