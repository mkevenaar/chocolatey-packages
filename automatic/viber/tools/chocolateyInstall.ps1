$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'https://download.cdn.viber.com/desktop/windows/29.4.0/ViberSetup.msi'
$checksum     = '87DA46D3F39174279E308B4920353CC21C235E43063802BB321462A6D0B31489'
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
