$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'https://exiftool.org/exiftool-12.50.zip'
$checksum     = 'd5ba2b249cb395f35e70d0d6b7cdfb39994de80a8754e433756a3b4773b146ee'
$checksumType = 'sha256'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  url           = $url
  checksum      = $checksum
  checksumType  = $checksumType
}

Install-ChocolateyZipPackage  @packageArgs

New-Item -ItemType SymbolicLink -Path "$(Join-Path $toolsDir 'exiftool.exe')" -Value "$(Join-Path $toolsDir 'exiftool(-k).exe')" -Force
