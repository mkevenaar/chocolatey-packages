$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/76.0.4017.88/win/Opera_beta_76.0.4017.88_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/76.0.4017.88/win/Opera_beta_76.0.4017.88_Setup_x64.exe'
  checksum       = '2b678afe0e02ccfd719554172f53058619999f439564ba31c8893742aff973ae'
  checksum64     = 'fbbe9880d21a65d8227a7acc7076622ee63d2727458bdf0b0e86bb0f02f25b0d'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '76.0.4017.88'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
