$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'https://exiftool.org/exiftool-12.53.zip'
$checksum     = '4baef9603e3d0704d485ab22b9e550f1e0c8333dd2ec821aad52a624a1140c5e'
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
