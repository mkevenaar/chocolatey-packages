$ErrorActionPreference = 'Stop';

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32 = 'https://dl.grafana.com/oss/release/grafana-12.3.3.windows-amd64.zip'
$checksum32 = '50aa8c3afb908672b63296d3c508bc39052e148a8e9bab1b74103c797e4bdc6c'
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
