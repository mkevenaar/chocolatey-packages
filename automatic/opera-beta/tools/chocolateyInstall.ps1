$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/104.0.4944.18/win/Opera_beta_104.0.4944.18_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/104.0.4944.18/win/Opera_beta_104.0.4944.18_Setup_x64.exe'
  checksum       = 'fc49aaa92e17b69f964511574de0a5b3741c4e2ad05bdfe4618d795a057da4ec'
  checksum64     = '2df771303cc3619038a35cce78f9f52890f858842a4ea84d692c5e54d4f80309'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '104.0.4944.18'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
