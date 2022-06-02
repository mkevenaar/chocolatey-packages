$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/88.0.4412.20/win/Opera_beta_88.0.4412.20_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/88.0.4412.20/win/Opera_beta_88.0.4412.20_Setup_x64.exe'
  checksum       = '86a45ed65422717026cfc79cb6634876de81272ebe173942c8aa5320d437e551'
  checksum64     = '6236dfb912b3ef0215a71515d5a8e5d296d0220ba7259cc5bbbfec9a7d18ee67'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '88.0.4412.20'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
