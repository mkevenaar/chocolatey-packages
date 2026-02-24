$ErrorActionPreference = 'Stop';

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32 = 'https://dl.grafana.com/oss/release/grafana-12.3.4.windows-amd64.zip'
$checksum32 = '20857ff28f419821261e8aa3f785f395fa8a343d4bde039dc777a30bf0e1138b'
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
