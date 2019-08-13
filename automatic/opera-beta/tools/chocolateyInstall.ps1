$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/63.0.3368.29/win/Opera_beta_63.0.3368.29_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/63.0.3368.29/win/Opera_beta_63.0.3368.29_Setup_x64.exe'
  checksum       = '79933ead0aff8f5e43a4095b630f85e6638a5e708f67407d085c2aada4161dea'
  checksum64     = 'eaf37658dd0979d8943773329bd5e1f64dbd9f85ca3d211906536ab5e106b10b'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '63.0.3368.29'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
