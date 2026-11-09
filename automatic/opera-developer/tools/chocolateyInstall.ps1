$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/141.0.6079.0/win/Opera_Developer_141.0.6079.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/141.0.6079.0/win/Opera_Developer_141.0.6079.0_Setup_x64.exe'
  checksum       = 'b8212dbdb06c8a703558c771655c5d62f6a62c663d639a9b6eaf898e4f884f69'
  checksum64     = '6587fa75459180a9ab3880f9b001bc28ebb91bfbb3e29d85274cf5be0fbde9cc'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '141.0.6079.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
