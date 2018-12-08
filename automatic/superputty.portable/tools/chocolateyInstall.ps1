$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url            = 'https://github.com/jimradford/superputty/releases/download/1.4.0.9/SuperPuTTY-1.4.0.9.zip'
$checksum       = 'a41d1a50d3a49c4ddb9d4071b5e29f759773ea96f10af1a5d263fc923847e437'
$checksumType   = 'sha256'
$packageVersion = $env:ChocolateyPackageVersion

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'SuperPuTTY*'
  fileType      = 'zip'
  silentArgs    = ""
  
  validExitCodes= @(0)
  url            = $url
  checksum       = $checksum
  checksumType   = $checksumType
  unzipLocation  = $toolsDir
}

Install-ChocolateyZipPackage @packageArgs

