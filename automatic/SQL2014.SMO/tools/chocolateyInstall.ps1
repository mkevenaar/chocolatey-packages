$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url32          = 'https://download.microsoft.com/download/6/7/8/67858AF1-B1B3-48B1-87C4-4483503E71DC/ENU/x86/SharedManagementObjects.msi'
$checksum32     = '6A5919A0C389EF5C8B568CCBCFB398CBE9B485B74BEE50246DE679695E7F590F'
$checksumType32 = 'sha256'
$url64          = 'https://download.microsoft.com/download/6/7/8/67858AF1-B1B3-48B1-87C4-4483503E71DC/ENU/x64/SharedManagementObjects.msi'
$checksum64     = 'ed28de290db64fa2274c49e160ea10c7f82cdfe94bad3d190f05d10220d53d0a'
$checksumType64 = 'sha256'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  unzipLocation  = $toolsDir
  fileType       = 'msi'
  url            = $url32
  checksum       = $checksum32
  checksumType   = $checksumType32
  url64bit      = $url64
  checksum64    = $checksum64
  checksumType64= $checksumType64
  softwareName  = 'Microsoft SQL Server 2014 Management Objects*'
  silentArgs    = "/qn /norestart /l*v `"$env:TEMP\$env:ChocolateyPackageName.$env:ChocolateyPackageVersion.log`""
  validExitCodes= @(0,1641,3010)
}

Install-ChocolateyPackage @packageArgs

# http://forums.iis.net/p/1174672/1968094.aspx
  # install both x86 and x64 editions of SMO since x64 supports both
  # to install both variants of powershell, both variants of SMO must be present
$IsSytem32Bit = (($Env:PROCESSOR_ARCHITECTURE -eq 'x86') -and `
  ($null -eq $Env:PROCESSOR_ARCHITEW6432))
if (!$IsSytem32Bit)
{
  $packageArgs.url64bit = $packageArgs.url
  $packageArgs.checksum64 = $packageArgs.checksum
  $packageArgs.checksumType64 = $packageArgs.checksumType
  Install-ChocolateyPackage @packageArgs
}
