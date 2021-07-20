$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.13.4-windows-x86_64.zip'
$checksum     = 'cefa96b7fab8695102e4fe161ee8e2a0649e47be0bddb6539c21b2c85c3b9e0d'
$checksumType = 'sha256'
$version      = "7.13.4"

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  unzipLocation  = $toolsDir
  url           = $url
  checksum      = $checksum
  checksumType  = $checksumType
}

Install-ChocolateyZipPackage  @packageArgs

$binPath = Join-Path $toolsDir "elasticsearch-$($version)\bin"

Install-ChocolateyPath $binPath 'Machine'

elasticsearch-service.bat install
