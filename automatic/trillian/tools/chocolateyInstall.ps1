$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'https://trillian.im/get/windows/6.5/trillian-v6.5.0.28.msi'
$checksum     = '12b5f801c139a3cd33be7eec1664d49f2acd018c25e1f0b188e498cb96421391'
$checksumType = 'sha256'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  unzipLocation  = $toolsDir
  fileType       = 'msi'
  url            = $url
  checksum       = $checksum
  checksumType   = $checksumType
  softwareName   = 'Trillian*'
  silentArgs     = "/quiet /qn /norestart"
  validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
