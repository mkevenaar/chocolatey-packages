$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.17.24-windows-x86_64.zip'
$checksum     = 'f708d7523d1e156560410848d0523f7922f4e2240b2e4f9ea59f104e56b41b6d'
$checksumType = 'sha256'
$version      = "7.17.24"

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
