$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'https://download.zerotier.com/RELEASES/1.4.0/dist/ZeroTier%20One.msi'
$checksum     = '6a5111a13f5af9dafcf8be713cad008cc7e8c567fe44275f85a141048539ddb4'
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
