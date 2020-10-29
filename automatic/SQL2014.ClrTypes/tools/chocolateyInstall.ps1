$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url32          = 'https://download.microsoft.com/download/6/7/8/67858AF1-B1B3-48B1-87C4-4483503E71DC/ENU/x86/SQLSysClrTypes.msi'
$checksum32     = '36EA8FA58DAC4C713FFD9FC51E4C44519D80D991ACFF22BECBFFB74561C481ED'
$checksumType32 = 'sha256'
$url64          = 'https://download.microsoft.com/download/6/7/8/67858AF1-B1B3-48B1-87C4-4483503E71DC/ENU/x64/SQLSysClrTypes.msi'
$checksum64     = '221f054daedf13096a8a04612e9a4d38cfe9b4988512538affc0bb6d7662fc7b'
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
  softwareName  = 'Microsoft System CLR Types for SQL Server 2014*'
  silentArgs    = "/qn /norestart /l*v `"$env:TEMP\$env:ChocolateyPackageName.$env:ChocolateyPackageVersion.log`""
  validExitCodes= @(0,1641,3010)
}

Install-ChocolateyPackage @packageArgs

# http://forums.iis.net/p/1174672/1968094.aspx
# it turns out that even on x64, x86 clr types should also be installed
# or SMO breaks
$IsSytem32Bit = (($Env:PROCESSOR_ARCHITECTURE -eq 'x86') -and `
  ($null -eq $Env:PROCESSOR_ARCHITEW6432))
if (!$IsSytem32Bit)
{
  $packageArgs.url64bit = $packageArgs.url
  $packageArgs.checksum64 = $packageArgs.checksum
  $packageArgs.checksumType64 = $packageArgs.checksumType
  Install-ChocolateyPackage @packageArgs
}
