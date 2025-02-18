$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-9.0.0-beta1-windows-x86_64.zip'
$checksum     = '83876dbaa730c1b099ea64c8d270a7cea6c381a8bca462d805f5e5ebd8fe1daa'
$checksumType = 'sha256'
$version      = "9.0.0-beta1"

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
