$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'https://exiftool.org/exiftool-12.52.zip'
$checksum     = 'd9c1fcb61ff8f893a536e2463103d3e6857aaa99455bc769ffdca99c7b6daae7'
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
