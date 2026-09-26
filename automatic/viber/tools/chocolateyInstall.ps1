$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'https://download.cdn.viber.com/desktop/windows/28.10.0/ViberSetup.msi'
$checksum     = '7DEB4BC0A8C0E3D2C27E6D605648689812B4495144ACBCAD8805315B2C4D9B6C'
$checksumType = 'sha256'
$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'msi'
  url64bit       = $url
  checksum64     = $checksum
  checksumType64 = $checksumType
  softwareName   = "Viber*"
  # BURNINSTALLATION suppresses the MSI's LaunchViber custom action.
  silentArgs     = '/qn /norestart BURNINSTALLATION=1'
  validExitCodes = @(0, 1641, 3010)
  destination    = $toolsDir
}

Install-ChocolateyPackage @packageArgs
