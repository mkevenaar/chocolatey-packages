$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://jaws2021.vfo.digital/2021.2105.53.400/2F7F244C-52EA-42F7-ABE4-1F6762CE1BDE/J2021.2105.53.400-Offline-x86.exe'
$checksum32     = 'd451d34734567499cd4a5811a3d06b7d68418371aa683f95fb4d26edb4f96caa'
$checksumType32 = 'sha256'
$url64          = 'https://jaws2021.vfo.digital/2021.2105.53.400/2F7F244C-52EA-42F7-ABE4-1F6762CE1BDE/J2021.2105.53.400-Offline-x64.exe'
$checksum64     = 'f08baa33997deb695dd4004b273de86b82e09859fb4c1029bbe88331198627c8'
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

