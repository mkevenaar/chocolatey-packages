$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://dymoreleasecontent.blob.core.windows.net/dymo-release/DCDWIN/DCDSetup1.6.1.7-X86.exe'
$checksum32     = 'b6137707fdda2ffb68163f2d3cd47d6298e6090b11bff2953eb392a63fbb2608'
$checksumType32 = 'sha256'
$url64          = 'https://dymoreleasecontent.blob.core.windows.net/dymo-release/DCDWIN/DCDSetup1.6.1.7-X64.exe'
$checksum64     = 'bd87261ed01a18ffcde6b47e5556372f546a95ee3d997afceb07c0094e3d6e50'
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

