$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/88.0.4412.18/win/Opera_beta_88.0.4412.18_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/88.0.4412.18/win/Opera_beta_88.0.4412.18_Setup_x64.exe'
  checksum       = '7f36d4bb98799742de66981dd87d9a0a93f11ce57ce5f50422e813918c33835e'
  checksum64     = 'd314169630733c4202a910e6362f7e68426fb229a22b3d90bbb90eeaacaacdca'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '88.0.4412.18'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
