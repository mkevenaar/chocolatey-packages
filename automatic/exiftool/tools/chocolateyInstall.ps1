$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'https://exiftool.org/exiftool-12.55.zip'
$checksum     = '9503b78fc9cdf1c4b142f9c6bbeebb21964f0acbbe4064dc28eca2390e450da4'
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
