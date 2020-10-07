$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'https://downloads.auslogics.com/en/duplicate-file-finder/duplicate-file-finder-setup.exe?clientId=1351721623.1602058280'
$checksum     = '080d55f422990b2b30f48bfcf79035a13e0615f570a64b17e36f8353ecbd652c'
$checksumType = 'sha256'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = $url
  checksum       = $checksum
  checksumType   = $checksumType
  softwareName   = "Auslogics Duplicate*"
  silentArgs     = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP- /TASKS=desktopicon'
  validExitCodes = @(0)
  destination   = $toolsDir
}

Install-ChocolateyPackage @packageArgs

