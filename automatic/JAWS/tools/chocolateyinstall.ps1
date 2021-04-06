$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://jaws2021.vfo.digital/2021.2103.174.400/55D02B58-3740-458C-9206-93438FFD29BB/J2021.2103.174.400-Offline-x86.exe'
$checksum32     = 'b5c1444103ff5206ffcf7d451886d08890176a383d80ee3fa0467c198c351955'
$checksumType32 = 'sha256'
$url64          = 'https://jaws2021.vfo.digital/2021.2103.174.400/55D02B58-3740-458C-9206-93438FFD29BB/J2021.2103.174.400-Offline-x64.exe'
$checksum64     = '48608d0e7c806391a153287ef9bc12b0ba52edc898a47a035cba072c5c26c3e4'
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

