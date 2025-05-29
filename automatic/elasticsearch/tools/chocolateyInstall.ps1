$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.18.2-windows-x86_64.zip'
$checksum     = '791ca898453dfa17336a5162aa5dd08a9efe8a10d88baa0a882ba7d336833b1b'
$checksumType = 'sha256'
$version      = "8.18.2"

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
