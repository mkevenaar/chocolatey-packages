$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'https://www.ceruleanstudios.com/trillian-v6.4.0.2.msi'
$checksum     = 'ff1dfc4e00a5e731a2c76e52e273c1f74a36db76650b96aec0fb0d1e67b6bb3c'
$checksumType = 'sha256'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  unzipLocation  = $toolsDir
  fileType       = 'msi'
  url            = $url
  checksum       = $checksum
  checksumType   = $checksumType
  softwareName   = 'Trillian*'
  silentArgs     = "/quiet /qn /norestart"
  validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
