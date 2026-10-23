$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://dymoreleasecontent.blob.core.windows.net/dymo-release/DCDWIN/DCDSetup1.6.4.6-X86.exe'
$checksum32     = '1e7f521214be124f1ebf62b7a45c9fc871091570aff36298736c577bd022fa52'
$checksumType32 = 'sha256'
$url64          = 'https://dymoreleasecontent.blob.core.windows.net/dymo-release/DCDWIN/DCDSetup1.6.4.6-X64.exe'
$checksum64     = '40f4512c0ab95559f6aee5da03c35af10c26403a23562e34e9419cd5bb2d9733'
$checksumType64 = 'sha256'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  softwareName   = 'DYMO Connect*'
  fileType       = 'exe'
  silentArgs     = "/s /v`"/qn`" /v`"REBOOT=ReallySuppress`" /sms"
  validExitCodes = @(0,1641,3010)
  url            = $url32
  checksum       = $checksum32
  checksumType   = $checksumType32
  url64bit       = $url64
  checksum64     = $checksum64
  checksumType64 = $checksumType64
  destination    = $toolsDir
}

Install-ChocolateyPackage @packageArgs

