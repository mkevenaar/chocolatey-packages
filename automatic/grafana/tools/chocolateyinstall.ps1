$ErrorActionPreference = 'Stop';

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32 = 'https://dl.grafana.com/oss/release/grafana-12.2.4.windows-amd64.zip'
$checksum32 = '8e1612c50aa99e42a589b2366d91ccb4193d08361d2049073dfc84c2b88fee8a'
$checksumType32 = 'sha256'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType      = 'zip'
  url           = $url32
  checksum      = $checksum32
  checksumType  = $checksumType32
}

Install-ChocolateyZipPackage @packageArgs
