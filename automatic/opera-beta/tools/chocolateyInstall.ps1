$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/92.0.4561.8/win/Opera_beta_92.0.4561.8_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/92.0.4561.8/win/Opera_beta_92.0.4561.8_Setup_x64.exe'
  checksum       = '60c088a760566edadebe2bfc93613b96d3ea9f4412566521b7e515d259fdd2b5'
  checksum64     = '8fea0c77da37891b7e7e2cd54fd6a91fb6bf3c5a76a84ff8d0a62c0ff4799a0d'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '92.0.4561.8'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
