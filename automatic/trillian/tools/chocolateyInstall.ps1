$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'http://cerulean.cachenetworks.com/trillian-v6.1.0.17.exe'
$checksum     = '1026a464829f8e2a3e44aecb72fb28b0ecbc8d5c2c1d7336f894fadcccf97a5e'
$checksumType = 'sha256'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  unzipLocation  = $toolsDir
  fileType       = 'exe'
  url            = $url
  checksum       = $checksum
  checksumType   = $checksumType
  softwareName   = 'Trillian*'
  silentArgs     = "/quiet /qn /norestart"
  validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
