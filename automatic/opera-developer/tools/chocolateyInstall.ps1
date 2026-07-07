$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/134.0.5952.0/win/Opera_Developer_134.0.5952.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/134.0.5952.0/win/Opera_Developer_134.0.5952.0_Setup_x64.exe'
  checksum       = 'd6aefa629deb9e581ac6f7d1657807d1079cbd3a670f2147fb00699f8b489500'
  checksum64     = '213bbfda94790d5ea7de90342eb8e4e31449d32d83e7c9aa0bf663d92ab98f60'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '134.0.5952.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
