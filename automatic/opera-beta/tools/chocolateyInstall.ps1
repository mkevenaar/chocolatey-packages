$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/83.0.4254.5/win/Opera_beta_83.0.4254.5_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/83.0.4254.5/win/Opera_beta_83.0.4254.5_Setup_x64.exe'
  checksum       = '6cabdfa9aa43a58a69e27d676e2ca0fa6694aba0ab4e90b853b9a8c72031e0b6'
  checksum64     = '4b1cc165ac7ab4104a5b406ca2f4471fa17798e5acfd4e5030595876c41ce643'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '83.0.4254.5'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
