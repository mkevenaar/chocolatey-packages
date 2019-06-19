$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/62.0.3331.14/win/Opera_beta_62.0.3331.14_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/62.0.3331.14/win/Opera_beta_62.0.3331.14_Setup_x64.exe'
  checksum       = '308ac9f0a43a3e99577639c31a39aeeb728fc94108a5fd628e2370d136e8e98e'
  checksum64     = 'bbd0f546b5f4a93d5ce6ebcc0f154bc9f7552fc6ffd51019d39fe76ff968b41b'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '62.0.3331.14'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
