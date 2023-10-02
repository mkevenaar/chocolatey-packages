$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://www.writage.com/Writage-2.13.msi'
$checksum32     = '0deb6c8ef8de11f13df91fb6b258ad7a1e86c2901edebce8b028b3251b2b5683'
$checksumType32 = 'sha256'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'Writage*'
  fileType      = 'msi'
  silentArgs    = "ALLUSERS=1 /qn /norestart /l*v `"$env:TEMP\$env:ChocolateyPackageName.$env:ChocolateyPackageVersion.log`""
  validExitCodes= @(0,1641,3010)
  url           = $url32
  checksum      = $checksum32
  checksumType  = $checksumType32
  destination   = $toolsDir
}

Install-ChocolateyPackage @packageArgs

