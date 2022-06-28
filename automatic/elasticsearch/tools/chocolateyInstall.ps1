$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.3.0-windows-x86_64.zip'
$checksum     = '95c69ae66b9caeeed8fb3884a0896e8b249fb8e0f89e9e2d62e5bd3298da83fb'
$checksumType = 'sha256'
$version      = "8.3.0"

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
