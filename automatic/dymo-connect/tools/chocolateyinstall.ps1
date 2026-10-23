$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://dymoreleasecontent.blob.core.windows.net/dymo-release/DCDWIN/DCDSetup1.6.4.4-X86.exe'
$checksum32     = 'b71d2b3fab89058312e0e7ca08c912c5512abf653e19b5659684baa7153c94fe'
$checksumType32 = 'sha256'
$url64          = 'https://dymoreleasecontent.blob.core.windows.net/dymo-release/DCDWIN/DCDSetup1.6.4.4-X64.exe'
$checksum64     = 'd504d747c301bc9147987cdc982d283f116e3d9c68ba3df690af4e72e60c9b78'
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

