$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/126.0.5750.30/win/Opera_beta_126.0.5750.30_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/126.0.5750.30/win/Opera_beta_126.0.5750.30_Setup_x64.exe'
  checksum       = '2cbc188be4c282e785b38cc556dbaf2f19afbb5e3e1f52001210da5579a1c0c1'
  checksum64     = 'a025984a70b63ce7914fcb3317976083b66682c811d06d3b8ff86c792e8efd04'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '126.0.5750.30'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
