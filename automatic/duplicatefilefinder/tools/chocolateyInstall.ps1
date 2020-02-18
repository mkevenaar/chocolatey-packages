$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'http://downloads.auslogics.com/en/duplicate-file-finder/duplicate-file-finder-setup.exe'
$checksum     = 'de84da2f9cccf331a8db0980238e56b0719b0f6bf03881b52b2066a63add843b'
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

