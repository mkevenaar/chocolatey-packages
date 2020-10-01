$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/72.0.3815.49/win/Opera_beta_72.0.3815.49_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/72.0.3815.49/win/Opera_beta_72.0.3815.49_Setup_x64.exe'
  checksum       = '29daa45a0f45631ff75eda04c371e2e5becf0100624452730a2061e6faec94ab'
  checksum64     = '5d2b04fb2085a49ab04de156fe2d1b8e0de70081c4d4ec611c568b8dda3fc738'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '72.0.3815.49'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
