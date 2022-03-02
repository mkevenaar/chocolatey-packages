$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/85.0.4341.6/win/Opera_beta_85.0.4341.6_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/85.0.4341.6/win/Opera_beta_85.0.4341.6_Setup_x64.exe'
  checksum       = 'e82a2d0d1ff785938ce2f0faa4527bd61be122f3572cf994e9fdffbc16bb7745'
  checksum64     = 'b623d0ce61810c875e625932adf71d6ea165e477e2619027fcd1b83c529b1111'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '85.0.4341.6'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
