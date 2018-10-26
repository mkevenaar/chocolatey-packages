$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'https://download.zerotier.com/RELEASES/1.2.12/dist/ZeroTier%20One.msi'
$checksum     = '05e9f984a53bb38c73df850c235933aa178343d412e616591ff058f731881f53'
$checksumType = 'sha256'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation  = $toolsDir
  fileType      = 'msi'
  url           = $url
  checksum      = $checksum
  checksumType  = $checksumType
  softwareName  = 'ZeroTier One*'
  silentArgs    = "/qn /norestart /l*v `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).MsiInstall.log`""
  validExitCodes= @(0,3010)
}

Install-ChocolateyPackage @packageArgs
