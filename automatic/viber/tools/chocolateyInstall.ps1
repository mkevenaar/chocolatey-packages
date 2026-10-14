$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'https://download.cdn.viber.com/desktop/windows/29.1.0/ViberSetup.msi'
$checksum     = '57C06AE156FBCD8D91900B415D6CB27DBFBD8B8E5C7496A8FE9F805A08802D41'
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
