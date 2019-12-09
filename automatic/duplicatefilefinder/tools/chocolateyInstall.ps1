$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'http://downloads.auslogics.com/en/duplicate-file-finder/duplicate-file-finder-setup.exe'
$checksum     = '29b304a9c7c4b208796c0866d189c7b7874fed85a2ba8942af577d9397e40fec'
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

