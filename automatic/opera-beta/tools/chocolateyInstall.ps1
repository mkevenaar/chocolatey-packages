$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/65.0.3467.16/win/Opera_beta_65.0.3467.16_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/65.0.3467.16/win/Opera_beta_65.0.3467.16_Setup_x64.exe'
  checksum       = '3c21a710dc1615073145515d69de397d858a1c293f7410adf15398f7749948d3'
  checksum64     = 'e6ab93429bd706ab6e4168f34d6b91a3ee3b1db4ef2151d6eff18e2ff3390f91'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '65.0.3467.16'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
