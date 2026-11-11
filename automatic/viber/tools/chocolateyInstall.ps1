$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'https://download.cdn.viber.com/desktop/windows/29.5.0/ViberSetup.msi'
$checksum     = '856A79E863729714170A60B40EEE53414D17B1CAB4C6B6A1077123DC47FF49E7'
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
