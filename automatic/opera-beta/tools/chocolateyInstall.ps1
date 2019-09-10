$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/64.0.3417.11/win/Opera_beta_64.0.3417.11_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/64.0.3417.11/win/Opera_beta_64.0.3417.11_Setup_x64.exe'
  checksum       = 'fd3a3374502c59bcc2e54e4a958de9adccc361ece43aa539d872a6231bb7c2ef'
  checksum64     = 'e8050168d2891c9d820d0d6491c0371628453af422c8910d45b9b7ef5d5b5977'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '64.0.3417.11'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
