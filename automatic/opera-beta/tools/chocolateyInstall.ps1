$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/64.0.3417.19/win/Opera_beta_64.0.3417.19_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/64.0.3417.19/win/Opera_beta_64.0.3417.19_Setup_x64.exe'
  checksum       = 'b403ae92c95d2940103860db08efdcbca9c432ea5832de99ecf1fd199b111544'
  checksum64     = 'a2aa15bbef16b627a36c36c85eb6aa1dc15796600c792828d36de2da66eacc05'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '64.0.3417.19'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
