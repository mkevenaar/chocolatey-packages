$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/68.0.3618.45/win/Opera_beta_68.0.3618.45_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/68.0.3618.45/win/Opera_beta_68.0.3618.45_Setup_x64.exe'
  checksum       = 'b9b6dcf0035b2f9b60eaccf36f6a100957ce1416b0adf4b4f24db8924d51ff47'
  checksum64     = 'b991f034ca271be58ff325388443dfdbfa5397a1b8cedd2939c93b20254b5cf6'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '68.0.3618.45'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
