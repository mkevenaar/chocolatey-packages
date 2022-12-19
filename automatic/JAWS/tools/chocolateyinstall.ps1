$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url64          = 'https://jaws2023.vfo.digital/2023.2212.23.400/5C7842B1-E618-46EB-9C1F-A67A61EC2FCF/J2023.2212.23.400-Offline-x64.exe'
$checksum64     = 'b25ded7820bb79ccd516b5cf7b740dbc71e9cbf431e8f8e06f8c765e0bd272c4'
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

