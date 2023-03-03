$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'https://trillian.im/get/windows/6.5/trillian-v6.5.0.26.msi'
$checksum     = '61e8bd361e0c40a8818eb757370fc3c0fa3d69ae90595ba79eff279c664d6ad6'
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
