$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url64          = 'https://jaws2023.vfo.digital/2023.2303.144.400/1B0E21E2-168A-4D3E-85EE-DD449C3C17D0/J2023.2303.144.400-Offline-x64.exe'
$checksum64     = '1804508eb24bcec5b700bdb3ce116bcf01807737e27e825f38f86cb51718f8ba'
$checksumType64 = 'sha256'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType      = 'exe'
  url64bit      = $url64
  checksum64    = $checksum64
  checksumType64= $checksumType64
  softwareName  = 'Freedom Scientific JAWS *'
  silentArgs    = "/Type Silent"
  validExitCodes= @(0)
}

Install-ChocolateyPackage @packageArgs

