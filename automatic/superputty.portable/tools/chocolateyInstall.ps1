$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url            = 'https://github.com/jimradford/superputty/releases/download/1.4.10/SuperPuTTY-1.4.10.zip'
$checksum       = 'bccfc1c289d42dcafa55d859ef6e8fdd15692561266aac27da852a22cf08aaa5'
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

