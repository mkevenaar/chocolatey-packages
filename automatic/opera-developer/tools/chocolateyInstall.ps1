$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/121.0.5565.0/win/Opera_Developer_121.0.5565.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/121.0.5565.0/win/Opera_Developer_121.0.5565.0_Setup_x64.exe'
  checksum       = 'cdf05b7e433b049056af047eb77f6ce98b462f5fe364145a9af9ae157ded90ee'
  checksum64     = '002433776b4d1bbe22f6b0dc3891b30adfcbe13cf06c977ac3bf0ae869f91947'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '121.0.5565.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
