$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.16.0-windows-x86_64.zip'
$checksum     = '19cb0ebfafbf5b8433c3379c1c529bf657ae5a5d1b072e3e5e56bd7d6f3fb612'
$checksumType = 'sha256'
$version      = "7.16.0"

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
