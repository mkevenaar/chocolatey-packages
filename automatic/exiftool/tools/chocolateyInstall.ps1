$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'https://exiftool.org/exiftool-12.54.zip'
$checksum     = '3c8b25b51d745e730c44903e547730e315b6fa77c68f169fe4af4f562a41e2d6'
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
