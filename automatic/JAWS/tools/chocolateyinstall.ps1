$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://jaws2022.vfo.digital/2022.2206.9.400/E6F61632-5F8C-40EA-840E-CBEAEACE27E5/J2022.2206.9.400-Offline-x86.exe'
$checksum32     = '3f900f07b67ac7fec75229b703857e34df2a2078804db5f37acb1d581f46b2f3'
$checksumType32 = 'sha256'
$url64          = 'https://jaws2022.vfo.digital/2022.2206.9.400/E6F61632-5F8C-40EA-840E-CBEAEACE27E5/J2022.2206.9.400-Offline-x64.exe'
$checksum64     = '7dab16dbcb22021c2afb3041599b106f20fdfbac39cfdcbfa5f27c4d2e7f4a00'
$checksumType64 = 'sha256'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType      = 'exe'
  url           = $url32
  checksum      = $checksum32
  checksumType  = $checksumType32
  url64bit      = $url64
  checksum64    = $checksum64
  checksumType64= $checksumType64
  softwareName  = 'Freedom Scientific JAWS 2020*'
  silentArgs    = "/Type Silent"
  validExitCodes= @(0)
}

Install-ChocolateyPackage @packageArgs

