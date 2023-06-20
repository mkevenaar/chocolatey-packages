$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url64          = 'https://jaws2023.vfo.digital/2023.2306.38.400/775C5615-98F0-4BCD-82B5-0D749FE94734/J2023.2306.38.400-Offline-x64.exe'
$checksum64     = 'ad1292864d2f499e10d78b7142fb20a7b36c29ccefa28bb7c8a36772329a584f'
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

