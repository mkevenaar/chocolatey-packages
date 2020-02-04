$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'http://jaws2020.vfo.digital/2020.2001.70.400/8D77F5FC-2F10-4262-8C44-AC333F339A45/J2020.2001.70.400-Offline-x86.exe'
$checksum32     = 'f70017cd011562cec232e100e1e0afcdb7386cee2875559b6455c25206ff922d'
$checksumType32 = 'sha256'
$url64          = 'http://jaws2020.vfo.digital/2020.2001.70.400/8D77F5FC-2F10-4262-8C44-AC333F339A45/J2020.2001.70.400-Offline-x64.exe'
$checksum64     = '498661cfd5c2cc90503089f98a9c6c4a4bea8f97a930bbd3fb0a978f9628c35f'
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

