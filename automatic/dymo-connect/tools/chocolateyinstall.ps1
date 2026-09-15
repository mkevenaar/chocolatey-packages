$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://dymoreleasecontent.blob.core.windows.net/dymo-release/DCDWIN/DCDSetup1.6.2.9-X86.exe'
$checksum32     = 'a6a45fef652c4932bcbbd3ae450d46873499fd2c9c8c589b570981e3072795e4'
$checksumType32 = 'sha256'
$url64          = 'https://dymoreleasecontent.blob.core.windows.net/dymo-release/DCDWIN/DCDSetup1.6.2.9-X64.exe'
$checksum64     = '99d1f4aaa87d00e0bbcd1c8faf33e1bb8a15183ae1678ffcafa16b100c63e7ef'
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

