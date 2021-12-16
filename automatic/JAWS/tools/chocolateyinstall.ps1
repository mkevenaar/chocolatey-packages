$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://jaws2022.vfo.digital/2022.2112.24.400/80824FB8-21F9-4D84-85EB-4008CD002070/J2022.2112.24.400-Offline-x86.exe'
$checksum32     = '334096b57ddd4d22ea204e24ba7b8f649336796959fd9591fd96ef57ec20ab3b'
$checksumType32 = 'sha256'
$url64          = 'https://jaws2022.vfo.digital/2022.2112.24.400/80824FB8-21F9-4D84-85EB-4008CD002070/J2022.2112.24.400-Offline-x64.exe'
$checksum64     = 'd78b04977f767566994515e71daa0bce1aa19f239ed0884c4df0ba21e9ba0c5a'
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

