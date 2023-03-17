$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url64          = 'https://meshmixer.com/downloads/Autodesk_Meshmixer_v3p5_Win64.exe'
$checksum64     = '5d08cb6254e4d4280137d6d37ec689fc3f0c61dad08bbc978a451ac16b7f271c'
$checksumType64 = 'sha256'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType      = 'exe'
  url64bit      = $url64
  checksum64    = $checksum64
  checksumType64= $checksumType64
  softwareName  = 'meshmixer*'
  silentArgs   = '/S'
  validExitCodes= @(0,1223)
}

Install-ChocolateyPackage @packageArgs

