$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.13.1-windows-x86_64.zip'
$checksum     = '22c6c3b91bd3f2c274c9af9e9cf64ddb204a3a1df3c54944529bafad023ba1af'
$checksumType = 'sha256'
$version      = "8.13.1"

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

$ErrorActionPreference = "SilentlyContinue";
elasticsearch-service.bat install
