$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'https://dl.grafana.com/oss/release/grafana-7.0.1.windows-amd64.zip'
$checksum     = '6360426e0f3803cb6322ed87b170392bb28e4d82b6237e4fc27164c5de4a4ccb'
$checksumType = 'sha256'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  unzipLocation  = $toolsDir
  url           = $url
  checksum      = $checksum
  checksumType  = $checksumType
}

Install-ChocolateyZipPackage  @packageArgs

