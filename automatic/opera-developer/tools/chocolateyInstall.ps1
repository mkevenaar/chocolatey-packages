$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/83.0.4253.0/win/Opera_Developer_83.0.4253.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/83.0.4253.0/win/Opera_Developer_83.0.4253.0_Setup_x64.exe'
  checksum       = 'b201b3b4acd7654c595d91b2e48eda196dd22414b65f2f36f980ecae0657c23c'
  checksum64     = '536147415087ba090af1fd250dff93c7b5b0afc5f0f31f3ed66d1b3d927d3002'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '83.0.4253.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
