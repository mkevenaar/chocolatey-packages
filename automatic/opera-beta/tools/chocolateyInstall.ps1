$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/101.0.4843.5/win/Opera_beta_101.0.4843.5_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/101.0.4843.5/win/Opera_beta_101.0.4843.5_Setup_x64.exe'
  checksum       = 'bca1b8aa7fe836e2913069ae59fc42f275abe9360333e5336edeb2b0d582204b'
  checksum64     = 'cb336b297a9c6659e49d9c89ec846d6d93297e30b57d3572efa325a8c33ee54d'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '101.0.4843.5'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
