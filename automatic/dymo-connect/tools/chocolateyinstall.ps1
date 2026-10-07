$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://dymoreleasecontent.blob.core.windows.net/dymo-release/DCDWIN/DCDSetup1.6.3.11-X86.exe'
$checksum32     = 'c7dc09fa0abb36ad606eacb691a0f2a90b8d901e39ac6e0034f929a269e9c998'
$checksumType32 = 'sha256'
$url64          = 'https://dymoreleasecontent.blob.core.windows.net/dymo-release/DCDWIN/DCDSetup1.6.3.11-X64.exe'
$checksum64     = '1305e9936e595b23128f2b92b070d02ae80a5a1ed6f2fc09011b8607fa28119f'
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

