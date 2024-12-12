$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.17.0-windows-x86_64.zip'
$checksum     = 'e1464426a28682cb73950da13738c3dc4825e3e9f144ee9d40a9f77f25539187'
$checksumType = 'sha256'
$version      = "8.17.0"

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
