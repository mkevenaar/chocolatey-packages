$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'https://download.cdn.viber.com/desktop/windows/29.3.0/ViberSetup.msi'
$checksum     = '7DB6264114EE1AD7EA13E34AE337AB37353FE34F66D50196627F6E0C3D0C92AF'
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
